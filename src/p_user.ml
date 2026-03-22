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

  Script: p_user.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import doomdef
import d_event
import p_local
import doomstat
import d_player
import info
import p_mobj
import p_pspr
import r_main

const INVERSECOLORMAP = 32

const MAXBOB = 0x100000
const _P_BOBANGLESTEP = 409
const _P_ANG5 = 59652323

onground = false

/*
* Function: _P_FineIndexFromAngle
* Purpose: Implements the _P_FineIndexFromAngle routine for the internal module support.
*/
function inline _P_FineIndexFromAngle(angle)
  if typeof(angle) != "int" then return 0 end if
  idx =(angle >> ANGLETOFINESHIFT) & FINEMASK
  if typeof(finecosine) == "array" and len(finecosine) > 0 and idx >= len(finecosine) then
    idx = idx % len(finecosine)
  end if
  if idx < 0 then idx = 0 end if
  return idx
end function

/*
* Function: _PU_WeaponIndex
* Purpose: Implements the _PU_WeaponIndex routine for the internal module support.
*/
function _PU_WeaponIndex(w)
  if typeof(w) == "int" then
    if w >= 0 and w < NUMWEAPONS then return w end if
    return -1
  end if
  if w == wp_fist then return 0 end if
  if w == wp_pistol then return 1 end if
  if w == wp_shotgun then return 2 end if
  if w == wp_chaingun then return 3 end if
  if w == wp_missile then return 4 end if
  if w == wp_plasma then return 5 end if
  if w == wp_bfg then return 6 end if
  if w == wp_chainsaw then return 7 end if
  if w == wp_supershotgun then return 8 end if
  return -1
end function

/*
* Function: _PU_PowerIndex
* Purpose: Implements the _PU_PowerIndex routine for the internal module support.
*/
function _PU_PowerIndex(pw)
  if typeof(pw) == "int" then
    if pw >= 0 and pw < NUMPOWERS then return pw end if
    return -1
  end if
  n = toNumber(pw)
  if typeof(n) == "int" then
    if n >= 0 and n < NUMPOWERS then return n end if
    return -1
  end if
  if pw == pw_invulnerability then return 0 end if
  if pw == pw_strength then return 1 end if
  if pw == pw_invisibility then return 2 end if
  if pw == pw_ironfeet then return 3 end if
  if pw == pw_allmap then return 4 end if
  if pw == pw_infrared then return 5 end if
  return -1
end function

/*
* Function: _PU_GetPower
* Purpose: Reads or updates state used by the internal module support.
*/
function _PU_GetPower(player, pw)
  if player is void then return 0 end if
  idx = _PU_PowerIndex(pw)
  if idx < 0 then return 0 end if
  if typeof(idx) != "int" then
    idxn = toNumber(idx)
    if typeof(idxn) != "int" then return 0 end if
    idx = idxn
  end if
  if typeof(player.powers) != "array" and typeof(player.powers) != "list" then return 0 end if
  if idx >= len(player.powers) then return 0 end if
  v = player.powers[idx]
  if typeof(v) != "int" then return 0 end if
  return v
end function

/*
* Function: _PU_SetPower
* Purpose: Reads or updates state used by the internal module support.
*/
function _PU_SetPower(player, pw, value)
  if player is void then return end if
  idx = _PU_PowerIndex(pw)
  if idx < 0 then return end if
  if typeof(idx) != "int" then
    idxn = toNumber(idx)
    if typeof(idxn) != "int" then return end if
    idx = idxn
  end if
  if typeof(player.powers) != "array" and typeof(player.powers) != "list" then return end if
  if idx >= len(player.powers) then return end if
  player.powers[idx] = value
end function

/*
* Function: _PU_HasWeapon
* Purpose: Implements the _PU_HasWeapon routine for the internal module support.
*/
function inline _PU_HasWeapon(player, w)
  if player is void then return false end if
  idx = _PU_WeaponIndex(w)
  if idx < 0 then return false end if
  if typeof(player.weaponowned) != "array" or idx >= len(player.weaponowned) then return false end if
  return player.weaponowned[idx]
end function

/*
* Function: P_Thrust
* Purpose: Implements the P_Thrust routine for the gameplay and world simulation.
*/
function P_Thrust(player, angle, move)
  if player is void or player.mo is void then return end if
  if finecosine is void or finesine is void then return end if

  ai = _P_FineIndexFromAngle(angle)
  if typeof(finecosine) != "array" or typeof(finesine) != "array" then return end if
  if ai < 0 or ai >= len(finecosine) or ai >= len(finesine) then return end if

  player.mo.momx = player.mo.momx + FixedMul(move, finecosine[ai])
  player.mo.momy = player.mo.momy + FixedMul(move, finesine[ai])
end function

/*
* Function: P_CalcHeight
* Purpose: Implements the P_CalcHeight routine for the gameplay and world simulation.
*/
function P_CalcHeight(player)
  if player is void or player.mo is void then return end if

  if typeof(player.mo.momx) != "int" then player.mo.momx = 0 end if
  if typeof(player.mo.momy) != "int" then player.mo.momy = 0 end if

  player.bob = FixedMul(player.mo.momx, player.mo.momx) + FixedMul(player.mo.momy, player.mo.momy)
  player.bob = player.bob >> 2
  if player.bob > MAXBOB then player.bob = MAXBOB end if

  if (player.cheats is not void and(player.cheats & cheat_t.CF_NOMOMENTUM) != 0) or(not onground) then
    player.viewz = player.mo.z + VIEWHEIGHT
    if player.viewz > player.mo.ceilingz - 4 * FRACUNIT then
      player.viewz = player.mo.ceilingz - 4 * FRACUNIT
    end if
    player.viewz = player.mo.z + player.viewheight
    return
  end if

  bob = 0
  if typeof(finesine) == "array" and len(finesine) > 0 then
    lt = leveltime
    if typeof(lt) != "int" then lt = 0 end if
    angle =(_P_BOBANGLESTEP * lt) & FINEMASK
    if angle < 0 then angle = 0 end if
    if angle >= len(finesine) then angle = angle % len(finesine) end if
    bob = FixedMul(player.bob >> 1, finesine[angle])
  end if

  if player.playerstate == playerstate_t.PST_LIVE then
    player.viewheight = player.viewheight + player.deltaviewheight

    if player.viewheight > VIEWHEIGHT then
      player.viewheight = VIEWHEIGHT
      player.deltaviewheight = 0
    end if

    if player.viewheight <(VIEWHEIGHT >> 1) then
      player.viewheight = VIEWHEIGHT >> 1
      if player.deltaviewheight <= 0 then player.deltaviewheight = 1 end if
    end if

    if player.deltaviewheight != 0 then
      player.deltaviewheight = player.deltaviewheight +(FRACUNIT >> 2)
      if player.deltaviewheight == 0 then player.deltaviewheight = 1 end if
    end if
  end if

  player.viewz = player.mo.z + player.viewheight + bob
  if player.viewz > player.mo.ceilingz - 4 * FRACUNIT then
    player.viewz = player.mo.ceilingz - 4 * FRACUNIT
  end if
end function

/*
* Function: P_MovePlayer
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_MovePlayer(player)
  global onground

  if player is void or player.mo is void then return end if

  cmd = player.cmd
  if cmd is void then return end if

  if cmd.angleturn is not void then
    player.mo.angle = player.mo.angle +(cmd.angleturn << 16)
  end if

  onground =(player.mo.z <= player.mo.floorz)

  if cmd.forwardmove is not void and cmd.forwardmove != 0 and onground then
    P_Thrust(player, player.mo.angle, cmd.forwardmove * 2048)
  end if

  if cmd.sidemove is not void and cmd.sidemove != 0 and onground then
    P_Thrust(player, player.mo.angle - ANG90, cmd.sidemove * 2048)
  end if

  if ((cmd.forwardmove is not void and cmd.forwardmove != 0) or(cmd.sidemove is not void and cmd.sidemove != 0)) then
    if player.mo.state == Info_StateAt(statenum_t.S_PLAY) then
      if typeof(P_SetMobjState) == "function" then
        P_SetMobjState(player.mo, statenum_t.S_PLAY_RUN1)
      end if
    end if
  end if
end function

/*
* Function: P_DeathThink
* Purpose: Advances per-tick logic for the gameplay and world simulation.
*/
function P_DeathThink(player)
  global onground

  if player is void or player.mo is void then return end if

  P_MovePsprites(player)

  if player.viewheight > 6 * FRACUNIT then
    player.viewheight = player.viewheight - FRACUNIT
  end if
  if player.viewheight < 6 * FRACUNIT then
    player.viewheight = 6 * FRACUNIT
  end if

  player.deltaviewheight = 0
  onground =(player.mo.z <= player.mo.floorz)
  P_CalcHeight(player)

  if player.attacker is not void and player.attacker != player.mo then
    angle = R_PointToAngle2(player.mo.x, player.mo.y, player.attacker.x, player.attacker.y)
    delta = angle - player.mo.angle

    if delta < _P_ANG5 or delta >(0 - _P_ANG5) then
      player.mo.angle = angle
      if player.damagecount > 0 then player.damagecount = player.damagecount - 1 end if
    else if delta < ANG180 then
      player.mo.angle = player.mo.angle + _P_ANG5
    else
      player.mo.angle = player.mo.angle - _P_ANG5
    end if
  else
    if player.damagecount > 0 then player.damagecount = player.damagecount - 1 end if
  end if

  if player.cmd is not void and(player.cmd.buttons & buttoncode_t.BT_USE) != 0 then
    player.playerstate = playerstate_t.PST_REBORN
  end if
end function

/*
* Function: P_PlayerThink
* Purpose: Advances per-tick logic for the gameplay and world simulation.
*/
function P_PlayerThink(player)
  if player is void then return end if
  if player.mo is void then return end if
  if player.cmd is void then player.cmd = ticcmd_t(0, 0, 0, 0, 0, 0) end if
  cmd = player.cmd

  if player.playerstate == playerstate_t.PST_LIVE then
    if (typeof(player.health) == "int" and player.health <= 0) or(typeof(player.mo.health) == "int" and player.mo.health <= 0) then
      player.playerstate = playerstate_t.PST_DEAD
    end if
  end if

  if (player.cheats & cheat_t.CF_NOCLIP) != 0 then
    player.mo.flags = player.mo.flags | mobjflag_t.MF_NOCLIP
  else
    player.mo.flags = player.mo.flags &(~mobjflag_t.MF_NOCLIP)
  end if

  if (player.mo.flags & mobjflag_t.MF_JUSTATTACKED) != 0 then
    cmd.angleturn = 0
    cmd.forwardmove = 100
    cmd.sidemove = 0
    player.mo.flags = player.mo.flags &(~mobjflag_t.MF_JUSTATTACKED)
  end if

  if player.playerstate == playerstate_t.PST_DEAD then
    P_DeathThink(player)
    return
  end if

  if player.mo.reactiontime > 0 then
    player.mo.reactiontime = player.mo.reactiontime - 1
  else
    P_MovePlayer(player)
  end if

  P_CalcHeight(player)

  if player.mo.subsector is not void and player.mo.subsector.sector is not void and player.mo.subsector.sector.special != 0 then
    P_PlayerInSpecialSector(player)
  end if

  if (cmd.buttons & buttoncode_t.BT_SPECIAL) != 0 then
    cmd.buttons = 0
  end if

  if (cmd.buttons & buttoncode_t.BT_CHANGE) != 0 then
    newweapon =(cmd.buttons & buttoncode_t.BT_WEAPONMASK) >> buttoncode_t.BT_WEAPONSHIFT
    readyweapon = _PU_WeaponIndex(player.readyweapon)

    if newweapon == _PU_WeaponIndex(wp_fist) and _PU_HasWeapon(player, wp_chainsaw) and not(readyweapon == _PU_WeaponIndex(wp_chainsaw) and _PU_GetPower(player, pw_strength) != 0) then
      newweapon = _PU_WeaponIndex(wp_chainsaw)
    end if

    if gamemode == GameMode_t.commercial and newweapon == _PU_WeaponIndex(wp_shotgun) and _PU_HasWeapon(player, wp_supershotgun) and readyweapon != _PU_WeaponIndex(wp_supershotgun) then
      newweapon = _PU_WeaponIndex(wp_supershotgun)
    end if

    if _PU_HasWeapon(player, newweapon) and newweapon != readyweapon then
      if (newweapon != _PU_WeaponIndex(wp_plasma) and newweapon != _PU_WeaponIndex(wp_bfg)) or(gamemode != GameMode_t.shareware) then
        player.pendingweapon = newweapon
      end if
    end if
  end if

  if (cmd.buttons & buttoncode_t.BT_USE) != 0 then
    if not player.usedown then
      P_UseLines(player)
      player.usedown = true
    end if
  else
    player.usedown = false
  end if

  P_MovePsprites(player)

  if _PU_GetPower(player, pw_strength) != 0 then _PU_SetPower(player, pw_strength, _PU_GetPower(player, pw_strength) + 1) end if
  if _PU_GetPower(player, pw_invulnerability) != 0 then _PU_SetPower(player, pw_invulnerability, _PU_GetPower(player, pw_invulnerability) - 1) end if

  if _PU_GetPower(player, pw_invisibility) != 0 then
    _PU_SetPower(player, pw_invisibility, _PU_GetPower(player, pw_invisibility) - 1)
    if _PU_GetPower(player, pw_invisibility) == 0 then
      player.mo.flags = player.mo.flags &(~mobjflag_t.MF_SHADOW)
    end if
  end if

  if _PU_GetPower(player, pw_infrared) != 0 then _PU_SetPower(player, pw_infrared, _PU_GetPower(player, pw_infrared) - 1) end if
  if _PU_GetPower(player, pw_ironfeet) != 0 then _PU_SetPower(player, pw_ironfeet, _PU_GetPower(player, pw_ironfeet) - 1) end if
  if player.damagecount > 0 then player.damagecount = player.damagecount - 1 end if
  if player.bonuscount > 0 then player.bonuscount = player.bonuscount - 1 end if

  if _PU_GetPower(player, pw_invulnerability) != 0 then
    if _PU_GetPower(player, pw_invulnerability) > 4 * 32 or(_PU_GetPower(player, pw_invulnerability) & 8) != 0 then
      player.fixedcolormap = INVERSECOLORMAP
    else
      player.fixedcolormap = 0
    end if
  else if _PU_GetPower(player, pw_infrared) != 0 then
    if _PU_GetPower(player, pw_infrared) > 4 * 32 or(_PU_GetPower(player, pw_infrared) & 8) != 0 then
      player.fixedcolormap = 1
    else
      player.fixedcolormap = 0
    end if
  else
    player.fixedcolormap = 0
  end if
end function



