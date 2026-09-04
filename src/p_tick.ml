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

//! Owns the intrusive thinker list and advances all world thinkers once per unpaused game tic.

import z_zone
import p_local
import doomstat
import p_user
import p_spec

/// Tracks the mutable leveltime value used by the p tick subsystem.
leveltime = 0

/// Tracks the mutable thinkercap value used by the p tick subsystem.
thinkercap = thinker_t(void, void, actionf_t(void, void, void), void)
/// Stores the ptk owner nodes collection used by the p tick subsystem.
/// @internal
_PTK_owner_nodes =[]
/// Stores the ptk owner vals collection used by the p tick subsystem.
/// @internal
_PTK_owner_vals =[]

/// Resets the thinker sentinel into an empty circular doubly linked list and clears owner bookkeeping.
function P_InitThinkers()
  global _PTK_owner_nodes
  global _PTK_owner_vals
  thinkercap.prev = thinkercap
  thinkercap.next = thinkercap
  _PTK_owner_nodes =[]
  _PTK_owner_vals =[]
end function

/// Associates a thinker node with its owning gameplay object in the fallback owner registry.
/// @param node Node value supplied to `P_RegisterThinkerOwner`.
/// @param owner Owner value supplied to `P_RegisterThinkerOwner`.
function P_RegisterThinkerOwner(node, owner)
  global _PTK_owner_nodes
  global _PTK_owner_vals
  if node is void then return end if
  node.owner = owner
  _PTK_owner_nodes = _PTK_owner_nodes +[node]
  _PTK_owner_vals = _PTK_owner_vals +[owner]
end function

/// Returns a thinker's direct owner or resolves it from the fallback registry used by legacy nodes.
/// @param node Node value supplied to `P_ResolveThinkerOwner`.
function P_ResolveThinkerOwner(node)
  if node is void then return void end if
  if typeof(node.owner) == "struct" then return node.owner end if
  i = len(_PTK_owner_nodes) - 1
  while i >= 0
    if _PTK_owner_nodes[i] == node then
      return _PTK_owner_vals[i]
    end if
    i = i - 1
  end while
  return void
end function

/// Removes a thinker-to-owner association when the node leaves the active thinker list.
/// @param node Node value supplied to `P_UnregisterThinkerOwner`.
function P_UnregisterThinkerOwner(node)
  global _PTK_owner_nodes
  global _PTK_owner_vals
  if node is void then return end if
  node.owner = void
  i = len(_PTK_owner_nodes) - 1
  while i >= 0
    if _PTK_owner_nodes[i] == node then
      _PTK_owner_nodes[i] = 0
      _PTK_owner_vals[i] = 0
      return
    end if
    i = i - 1
  end while
end function

/// Adds thinker entries to the play simulation.
/// @param thinker Thinker value supplied to `P_AddThinker`.
function P_AddThinker(thinker)

  if thinker is void then return end if

  tail = thinkercap.prev
  tail.next = thinker
  thinker.prev = tail
  thinker.next = thinkercap
  thinkercap.prev = thinker
end function

/// Removes remove Thinker data from the play simulation system.
/// @param thinker Thinker value supplied to `P_RemoveThinker`.
function P_RemoveThinker(thinker)

  if thinker is void then return end if
  P_UnregisterThinkerOwner(thinker)
  if thinker.func is void then
    thinker.func = actionf_t(void, -1, void)
  else
    thinker.func.acv = -1
  end if
end function

/// Constructs an unlinked thinker node with an empty callback and owner slot.
/// @param thinker Thinker value supplied to `P_AllocateThinker`.
function P_AllocateThinker(thinker)

  thinker = thinker
end function

/// Walks the thinker list safely across removals and invokes each active callback with its resolved owner.
function P_RunThinkers()
  profileThinkers = false
  if typeof(_d_profile_render) == "bool" and _d_profile_render and typeof(_D_ProfileThinker) == "function" then
    profileThinkers = true
  end if
  cur = thinkercap.next
  while cur != thinkercap
    next = cur.next

    if cur.func is not void and cur.func.acv == -1 then

      cur.next.prev = cur.prev
      cur.prev.next = cur.next
      P_UnregisterThinkerOwner(cur)

      if typeof(Z_Free) == "function" then

      end if

    else
      if cur.func is not void and typeof(cur.func.acp1) == "function" then
        owner = cur
        if typeof(cur.owner) == "struct" then
          owner = cur.owner
        else
          o = P_ResolveThinkerOwner(cur)
          if o is not void then owner = o end if
        end if
        if profileThinkers then
          isMobj = false
          if typeof(P_MobjThinker) == "function" and cur.func.acp1 == P_MobjThinker then isMobj = true end if
          _D_ProfileThinker(isMobj)
        end if
        cur.func.acp1(owner)
      end if
    end if

    cur = next
  end while
end function

/// Advances only active player mobjs while the developer freeze suspends every other world thinker.
function P_RunFrozenPlayerMobjs()
  i = 0
  while i < MAXPLAYERS
    if i < len(playeringame) and playeringame[i] and i < len(players) and typeof(players[i]) == "struct" then
      player = players[i]
      if player.mo is not void and typeof(P_MobjThinker) == "function" then
        P_MobjThinker(player.mo)
      end if
    end if
    i = i + 1
  end while
end function

/// Advances players, thinkers, and sector specials once per unpaused game tic, then increments level time.
function P_Ticker()
  global leveltime

  if paused then return end if

  if (not netgame) and menuactive and(not demoplayback) then
    if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" and players[consoleplayer].viewz != 1 then
      return
    end if
  end if

  i = 0
  profiling = false
  if typeof(_d_profile_render) == "bool" and _d_profile_render and typeof(_D_ProfileTimeUs) == "function" and typeof(_D_ProfileAdd) == "function" then
    profiling = true
  end if
  if profiling and typeof(_D_ProfileGameTick) == "function" then _D_ProfileGameTick() end if
  t0 = 0
  if profiling then t0 = _D_ProfileTimeUs() end if
  while i < MAXPLAYERS
    if i < len(playeringame) and playeringame[i] then
      if typeof(P_PlayerThink) == "function" and i < len(players) and typeof(players[i]) == "struct" then
        P_PlayerThink(players[i])
      end if
    end if
    i = i + 1
  end while
  if profiling then _D_ProfileAdd(7, _D_ProfileTimeUs() - t0) end if

  // PlayerThink creates momentum; the player's mobj thinker must consume it even while the world is frozen.
  if consolefreeze then
    P_RunFrozenPlayerMobjs()
    return
  end if

  if profiling then t0 = _D_ProfileTimeUs() end if
  P_RunThinkers()
  if profiling then _D_ProfileAdd(8, _D_ProfileTimeUs() - t0) end if

  if profiling then t0 = _D_ProfileTimeUs() end if
  if typeof(P_UpdateSpecials) == "function" then P_UpdateSpecials() end if
  if typeof(P_RespawnSpecials) == "function" then P_RespawnSpecials() end if
  if profiling then _D_ProfileAdd(9, _D_ProfileTimeUs() - t0) end if

  leveltime = leveltime + 1
end function



