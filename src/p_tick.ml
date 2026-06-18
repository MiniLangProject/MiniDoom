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

  Script: p_tick.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import p_local
import doomstat
import p_user
import p_spec

leveltime = 0

thinkercap = thinker_t(void, void, actionf_t(void, void, void), void)
_PTK_owner_nodes =[]
_PTK_owner_vals =[]

/*
* Function: P_InitThinkers
* Purpose: Initializes state and dependencies for the gameplay and world simulation.
*/
function P_InitThinkers()
  global _PTK_owner_nodes
  global _PTK_owner_vals
  thinkercap.prev = thinkercap
  thinkercap.next = thinkercap
  _PTK_owner_nodes =[]
  _PTK_owner_vals =[]
end function

/*
* Function: P_RegisterThinkerOwner
* Purpose: Advances register Thinker Owner logic during the play simulation tick.
*/
function P_RegisterThinkerOwner(node, owner)
  global _PTK_owner_nodes
  global _PTK_owner_vals
  if node is void then return end if
  node.owner = owner
  _PTK_owner_nodes = _PTK_owner_nodes +[node]
  _PTK_owner_vals = _PTK_owner_vals +[owner]
end function

/*
* Function: P_ResolveThinkerOwner
* Purpose: Advances resolve Thinker Owner logic during the play simulation tick.
*/
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

/*
* Function: P_UnregisterThinkerOwner
* Purpose: Advances unregister Thinker Owner logic during the play simulation tick.
*/
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

/*
* Function: P_AddThinker
* Purpose: Adds thinker entries to the play simulation.
*/
function P_AddThinker(thinker)

  if thinker is void then return end if

  tail = thinkercap.prev
  tail.next = thinker
  thinker.prev = tail
  thinker.next = thinkercap
  thinkercap.prev = thinker
end function

/*
* Function: P_RemoveThinker
* Purpose: Removes remove Thinker data from the play simulation system.
*/
function P_RemoveThinker(thinker)

  if thinker is void then return end if
  P_UnregisterThinkerOwner(thinker)
  if thinker.func is void then
    thinker.func = actionf_t(void, -1, void)
  else
    thinker.func.acv = -1
  end if
end function

/*
* Function: P_AllocateThinker
* Purpose: Advances allocate Thinker logic during the play simulation tick.
*/
function P_AllocateThinker(thinker)

  thinker = thinker
end function

/*
* Function: P_RunThinkers
* Purpose: Advances run Thinkers logic during the play simulation tick.
*/
function P_RunThinkers()
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
        isMobj = false
        if typeof(P_MobjThinker) == "function" and cur.func.acp1 == P_MobjThinker then isMobj = true end if
        if typeof(_D_ProfileThinker) == "function" then _D_ProfileThinker(isMobj) end if
        cur.func.acp1(owner)
      end if
    end if

    cur = next
  end while
end function

/*
* Function: P_Ticker
* Purpose: Advances ticker logic during the play simulation tick.
*/
function P_Ticker()
  global leveltime

  if paused then return end if

  if (not netgame) and menuactive and(not demoplayback) then
    if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" and players[consoleplayer].viewz != 1 then
      return
    end if
  end if

  i = 0
  if typeof(_D_ProfileGameTick) == "function" then _D_ProfileGameTick() end if
  t0 = 0
  if typeof(_D_TimeMs) == "function" then t0 = _D_TimeMs() end if
  while i < MAXPLAYERS
    if i < len(playeringame) and playeringame[i] then
      if typeof(P_PlayerThink) == "function" and i < len(players) and typeof(players[i]) == "struct" then
        P_PlayerThink(players[i])
      end if
    end if
    i = i + 1
  end while
  if typeof(_D_ProfileAdd) == "function" and typeof(_D_TimeMs) == "function" then _D_ProfileAdd(7, _D_TimeMs() - t0) end if

  if typeof(_D_TimeMs) == "function" then t0 = _D_TimeMs() end if
  P_RunThinkers()
  if typeof(_D_ProfileAdd) == "function" and typeof(_D_TimeMs) == "function" then _D_ProfileAdd(8, _D_TimeMs() - t0) end if

  if typeof(_D_TimeMs) == "function" then t0 = _D_TimeMs() end if
  if typeof(P_UpdateSpecials) == "function" then P_UpdateSpecials() end if
  if typeof(P_RespawnSpecials) == "function" then P_RespawnSpecials() end if
  if typeof(_D_ProfileAdd) == "function" and typeof(_D_TimeMs) == "function" then _D_ProfileAdd(9, _D_TimeMs() - t0) end if

  leveltime = leveltime + 1
end function



