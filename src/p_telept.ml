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

  Script: p_telept.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import doomdef
import tables
import s_sound
import p_local
import p_mobj
import p_tick
import sounds
import r_state

/*
* Function: _PTP_ResolveThinkerMobj
* Purpose: Advances per-tick logic for the internal module support.
*/
function _PTP_ResolveThinkerMobj(th)
  if th is void then return void end if

  if typeof(P_ResolveThinkerOwner) == "function" then
    mo = P_ResolveThinkerOwner(th)
    if mo is not void then return mo end if
  end if

  if typeof(_PM_ResolveThinkerOwner) == "function" then
    mo = _PM_ResolveThinkerOwner(th)
    if mo is not void then return mo end if
  end if

  if typeof(th.type) == "int" and typeof(th.x) == "int" and typeof(th.y) == "int" then
    return th
  end if

  return void
end function

/*
* Function: EV_Teleport
* Purpose: Implements the EV_Teleport routine for the engine module behavior.
*/
function EV_Teleport(line, side, thing)
  if line is void or thing is void then return 0 end if

  if (thing.flags & mobjflag_t.MF_MISSILE) != 0 then return 0 end if

  if side == 1 then return 0 end if

  tag = line.tag
  if typeof(sectors) != "array" then return 0 end if

  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void and sec.tag == tag then
      thinker = thinkercap.next
      while thinker is not void and thinker != thinkercap
        m = _PTP_ResolveThinkerMobj(thinker)
        if m is not void and m.type == mobjtype_t.MT_TELEPORTMAN and m.subsector is not void and m.subsector.sector == sec then
          oldx = thing.x
          oldy = thing.y
          oldz = thing.z

          if not P_TeleportMove(thing, m.x, m.y) then
            return 0
          end if

          thing.z = thing.floorz
          if thing.player is not void then
            thing.player.viewz = thing.z + thing.player.viewheight
          end if

          fog = P_SpawnMobj(oldx, oldy, oldz, mobjtype_t.MT_TFOG)
          if fog is not void and typeof(S_StartSound) == "function" then
            S_StartSound(fog, sfxenum_t.sfx_telept)
          end if

          an =(m.angle >> ANGLETOFINESHIFT) & FINEMASK
          fog = P_SpawnMobj(m.x + 20 * finecosine[an], m.y + 20 * finesine[an], thing.z, mobjtype_t.MT_TFOG)
          if fog is not void and typeof(S_StartSound) == "function" then
            S_StartSound(fog, sfxenum_t.sfx_telept)
          end if

          if thing.player is not void then
            thing.reactiontime = 18
          end if

          thing.angle = m.angle
          thing.momx = 0
          thing.momy = 0
          thing.momz = 0
          return 1
        end if

        thinker = thinker.next
      end while
    end if
    i = i + 1
  end while

  return 0
end function



