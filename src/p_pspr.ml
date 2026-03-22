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

  Script: p_pspr.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import m_fixed
import tables
import info
import doomdef
import d_event
import m_random
import p_local
import p_map
import p_inter
import p_mobj
import p_enemy
import r_main
import s_sound
import doomstat
import sounds
import m_argv
import p_pspr

const FF_FULLBRIGHT = 0x8000
const FF_FRAMEMASK = 0x7fff

/*
* Enum: psprnum_t
* Purpose: Defines named constants for psprnum type.
*/
enum psprnum_t
  ps_weapon
  ps_flash
  NUMPSPRITES
end enum

ps_weapon = 0
ps_flash = 1
NUMPSPRITES = 2

/*
* Struct: pspdef_t
* Purpose: Stores runtime data for pspdef type.
*/
struct pspdef_t
  state
  tics
  sx
  sy
end struct

const LOWERSPEED = 393216
const RAISESPEED = 393216

const WEAPONBOTTOM = 8388608
const WEAPONTOP = 2097152

const BFGCELLS = 40
const _PS_SWINGSTEP = 117
const _PS_HALF_FINEANGLES = 4096
const _PS_ANG90_DIV20 = 53687091
const _PS_ANG90_DIV21 = 51130563
const _PS_ANG90_DIV40 = 26843545

swingx = 0
swingy = 0

bulletslope = 0

_psDiagFireInit = false
_psDiagFire = false
_psDiagFireCount = 0

/*
* Function: _PS_DiagFireEnabled
* Purpose: Implements the _PS_DiagFireEnabled routine for the internal module support.
*/
function _PS_DiagFireEnabled()
  global _psDiagFireInit
  global _psDiagFire
  if _psDiagFireInit then return _psDiagFire end if
  _psDiagFireInit = true
  _psDiagFire = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diagfire") or M_CheckParm("--diagfire") then
      _psDiagFire = true
    end if
  end if
  if _psDiagFire then
    print "P_Pspr: -diagfire enabled"
  end if
  return _psDiagFire
end function

/*
* Function: _PS_DiagFireLog
* Purpose: Implements the _PS_DiagFireLog routine for the internal module support.
*/
function inline _PS_DiagFireLog(msg)
  global _psDiagFireCount
  if not _PS_DiagFireEnabled() then return end if
  if typeof(msg) != "string" then return end if
  _psDiagFireCount = _psDiagFireCount + 1
  if _psDiagFireCount <= 120 or(_psDiagFireCount & 255) == 0 then
    print "P_Fire: " + msg
  end if
end function

/*
* Function: _PS_WeaponIndex
* Purpose: Implements the _PS_WeaponIndex routine for the internal module support.
*/
function _PS_WeaponIndex(w)
  if typeof(w) == "int" then
    if w >= 0 and w < 9 then return w end if
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
* Function: _PS_AmmoIndex
* Purpose: Implements the _PS_AmmoIndex routine for the internal module support.
*/
function inline _PS_AmmoIndex(a)
  if typeof(a) == "int" then
    if a >= 0 and a < 4 then return a end if
    return -1
  end if
  if a == am_clip then return 0 end if
  if a == am_shell then return 1 end if
  if a == am_cell then return 2 end if
  if a == am_misl then return 3 end if
  return -1
end function

/*
* Function: _PS_PowerIndex
* Purpose: Implements the _PS_PowerIndex routine for the internal module support.
*/
function _PS_PowerIndex(pw)
  if typeof(pw) == "int" then
    if pw >= 0 and pw < 6 then return pw end if
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
* Function: _PS_WeaponInfo
* Purpose: Implements the _PS_WeaponInfo routine for the internal module support.
*/
function inline _PS_WeaponInfo(w)
  wi = _PS_WeaponIndex(w)
  if wi < 0 then return void end if
  if typeof(weaponinfo) != "array" then return void end if
  if wi >= len(weaponinfo) then return void end if
  return weaponinfo[wi]
end function

/*
* Function: _PS_GetAmmoCount
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _PS_GetAmmoCount(player, ammoType)
  if player is void then return 0 end if
  ai = _PS_AmmoIndex(ammoType)
  if ai < 0 then return 0 end if
  if typeof(player.ammo) != "array" then return 0 end if
  if ai >= len(player.ammo) then return 0 end if
  v = player.ammo[ai]
  if typeof(v) == "int" then return v end if
  if v then return 1 end if
  return 0
end function

/*
* Function: _PS_SetAmmoCount
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _PS_SetAmmoCount(player, ammoType, value)
  if player is void then return end if
  ai = _PS_AmmoIndex(ammoType)
  if ai < 0 then return end if
  if typeof(player.ammo) != "array" then return end if
  if ai >= len(player.ammo) then return end if
  if typeof(value) != "int" then value = 0 end if
  if value < 0 then value = 0 end if
  player.ammo[ai] = value
end function

/*
* Function: _PS_HasWeapon
* Purpose: Implements the _PS_HasWeapon routine for the internal module support.
*/
function inline _PS_HasWeapon(player, weaponType)
  if player is void then return false end if
  wi = _PS_WeaponIndex(weaponType)
  if wi < 0 then return false end if
  if typeof(player.weaponowned) != "array" then return false end if
  if wi >= len(player.weaponowned) then return false end if
  if player.weaponowned[wi] then return true end if
  return false
end function

/*
* Function: _PS_StateObjectIndex
* Purpose: Implements the _PS_StateObjectIndex routine for the internal module support.
*/
function _PS_StateObjectIndex(stobj)
  if stobj is void then return -1 end if
  if typeof(states) != "array" then return -1 end if
  i = 0
  while i < len(states)
    if states[i] == stobj then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _PS_PSpriteInState
* Purpose: Implements the _PS_PSpriteInState routine for the internal module support.
*/
function inline _PS_PSpriteInState(psp, stnum)
  if psp is void then return false end if
  if psp.state is void then return false end if
  s = Info_StateAt(stnum)
  if s is void then return false end if
  return psp.state == s
end function

/*
* Function: _PS_MobjInState
* Purpose: Implements the _PS_MobjInState routine for the internal module support.
*/
function inline _PS_MobjInState(mo, stnum)
  if mo is void then return false end if
  if mo.state is void then return false end if
  s = Info_StateAt(stnum)
  if s is void then return false end if
  return mo.state == s
end function

/*
* Function: _PS_PlaySound
* Purpose: Implements the _PS_PlaySound routine for the internal module support.
*/
function inline _PS_PlaySound(origin, sfx)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, sfx)
  end if
end function

/*
* Function: _ensurePsprites
* Purpose: Implements the _ensurePsprites routine for the internal module support.
*/
function _ensurePsprites(player)
  if player is void then return end if
  if player.psprites is void then
    player.psprites =[]
  end if

  i = len(player.psprites)
  while i < NUMPSPRITES
    player.psprites = player.psprites +[pspdef_t(void, 0, 0, 0)]
    i = i + 1
  end while
end function

/*
* Function: P_SetPsprite
* Purpose: Reads or updates state used by the gameplay and world simulation.
*/
function P_SetPsprite(player, position, stnum)
  _ensurePsprites(player)
  if player is void then return end if
  if player.psprites is void then return end if
  if position < 0 or position >= len(player.psprites) then return end if

  psp = player.psprites[position]

  loop

    if stnum is void or stnum == statenum_t.S_NULL or stnum == 0 then
      psp.state = void
      break
    end if

    stidx = Info_StateIndex(stnum)
    if stidx < 0 then
      psp.state = void
      break
    end if

    if typeof(states) != "array" then
      psp.state = stnum
      psp.tics = 1
      break
    end if
    if stidx >= len(states) then
      psp.state = void
      break
    end if

    state = states[stidx]
    psp.state = state
    psp.tics = state.tics

    if state is not void and state.misc1 is not void and state.misc1 != 0 then
      psp.sx = state.misc1 << FRACBITS
      psp.sy = state.misc2 << FRACBITS
    end if

    if state is not void and state.action is not void then
      if typeof(state.action.acp2) == "function" then
        state.action.acp2(player, psp)
      else if typeof(state.action.acp1) == "function" then
        state.action.acp1(player, psp)
      end if
      if psp.state is void then break end if
    end if

    if psp.state is void then break end if
    stnum = psp.state.nextstate

    if psp.tics is not void and psp.tics != 0 then break end if
    while true
    end loop
  end function

  /*
  * Function: P_CalcSwing
  * Purpose: Implements the P_CalcSwing routine for the gameplay and world simulation.
  */
  function P_CalcSwing(player)
    global swingx
    global swingy

    if player is void then
      swingx = 0
      swingy = 0
      return
    end if
    if finesine is void then
      swingx = 0
      swingy = 0
      return
    end if

    swing = player.bob
    angle =(_PS_SWINGSTEP * leveltime) & FINEMASK
    swingx = FixedMul(swing, finesine[angle])

    angle =(_PS_SWINGSTEP * leveltime + _PS_HALF_FINEANGLES) & FINEMASK
    swingy = -FixedMul(swingx, finesine[angle])
  end function

  /*
  * Function: P_BringUpWeapon
  * Purpose: Implements the P_BringUpWeapon routine for the gameplay and world simulation.
  */
  function P_BringUpWeapon(player)
    if player is void then return end if
    _ensurePsprites(player)

    if player.pendingweapon == wp_nochange then
      player.pendingweapon = player.readyweapon
    end if

    if player.pendingweapon == wp_chainsaw then
      _PS_PlaySound(player.mo, sfxenum_t.sfx_sawup)
    end if

    wi = _PS_WeaponInfo(player.pendingweapon)
    if wi is void then return end if
    newstate = wi.upstate

    player.pendingweapon = wp_nochange
    player.psprites[ps_weapon].sy = WEAPONBOTTOM

    P_SetPsprite(player, ps_flash, statenum_t.S_NULL)

    P_SetPsprite(player, ps_weapon, newstate)
  end function

  /*
  * Function: P_CheckAmmo
  * Purpose: Evaluates conditions and returns a decision for the gameplay and world simulation.
  */
  function P_CheckAmmo(player)
    if player is void then return true end if

    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return true end if

    ammo = wi.ammo

    count = 1
    if player.readyweapon == wp_bfg then
      count = BFGCELLS
    else if player.readyweapon == wp_supershotgun then
      count = 2
    end if

    ai = _PS_AmmoIndex(ammo)
    if ai < 0 then return true end if
    if _PS_GetAmmoCount(player, ammo) >= count then return true end if

    pw = wp_fist
    if _PS_HasWeapon(player, wp_plasma) and _PS_GetAmmoCount(player, am_cell) > 0 and(gamemode != shareware) then
      pw = wp_plasma
    else if _PS_HasWeapon(player, wp_supershotgun) and _PS_GetAmmoCount(player, am_shell) > 2 and(gamemode == commercial) then
      pw = wp_supershotgun
    else if _PS_HasWeapon(player, wp_chaingun) and _PS_GetAmmoCount(player, am_clip) > 0 then
      pw = wp_chaingun
    else if _PS_HasWeapon(player, wp_shotgun) and _PS_GetAmmoCount(player, am_shell) > 0 then
      pw = wp_shotgun
    else if _PS_GetAmmoCount(player, am_clip) > 0 then
      pw = wp_pistol
    else if _PS_HasWeapon(player, wp_chainsaw) then
      pw = wp_chainsaw
    else if _PS_HasWeapon(player, wp_missile) and _PS_GetAmmoCount(player, am_misl) > 0 then
      pw = wp_missile
    else if _PS_HasWeapon(player, wp_bfg) and _PS_GetAmmoCount(player, am_cell) > 40 and(gamemode != shareware) then
      pw = wp_bfg
    end if

    player.pendingweapon = pw

    P_SetPsprite(player, ps_weapon, wi.downstate)
    return false
  end function

  /*
  * Function: P_FireWeapon
  * Purpose: Implements the P_FireWeapon routine for the gameplay and world simulation.
  */
  function P_FireWeapon(player)
    if player is void then return end if
    if not P_CheckAmmo(player) then return end if

    if typeof(P_SetMobjState) == "function" and player.mo is not void then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK1)
    end if

    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is not void then
      P_SetPsprite(player, ps_weapon, wi.atkstate)
    end if

    if typeof(P_NoiseAlert) == "function" and player.mo is not void then
      P_NoiseAlert(player.mo, player.mo)
    end if
  end function

  /*
  * Function: P_DropWeapon
  * Purpose: Implements the P_DropWeapon routine for the gameplay and world simulation.
  */
  function P_DropWeapon(player)
    if player is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    P_SetPsprite(player, ps_weapon, wi.downstate)
  end function

  /*
  * Function: P_SetupPsprites
  * Purpose: Reads or updates state used by the gameplay and world simulation.
  */
  function P_SetupPsprites(player)
    if player is void then return end if
    _ensurePsprites(player)

    i = 0
    while i < NUMPSPRITES
      player.psprites[i].state = void
      i = i + 1
    end while

    player.pendingweapon = player.readyweapon
    P_BringUpWeapon(player)
  end function

  /*
  * Function: P_MovePsprites
  * Purpose: Computes movement/collision behavior in the gameplay and world simulation.
  */
  function P_MovePsprites(player)
    if player is void then return end if
    _ensurePsprites(player)

    i = 0
    while i < NUMPSPRITES
      psp = player.psprites[i]
      state = psp.state
      if state is not void then
        if psp.tics != -1 then
          psp.tics = psp.tics - 1
          if psp.tics == 0 then
            if state is not void then
              P_SetPsprite(player, i, state.nextstate)
            end if
          end if
        end if
      end if
      i = i + 1
    end while

    player.psprites[ps_flash].sx = player.psprites[ps_weapon].sx
    player.psprites[ps_flash].sy = player.psprites[ps_weapon].sy
  end function

  /*
  * Function: A_WeaponReady
  * Purpose: Implements the A_WeaponReady routine for the engine module behavior.
  */
  function A_WeaponReady(player, psp)
    if player is void or psp is void then return end if

    if player.mo is not void and(_PS_MobjInState(player.mo, statenum_t.S_PLAY_ATK1) or _PS_MobjInState(player.mo, statenum_t.S_PLAY_ATK2)) then
      if typeof(P_SetMobjState) == "function" then
        P_SetMobjState(player.mo, statenum_t.S_PLAY)
      end if
    end if

    if player.readyweapon == wp_chainsaw and _PS_PSpriteInState(psp, statenum_t.S_SAW) then
      _PS_PlaySound(player.mo, sfxenum_t.sfx_sawidl)
    end if

    if player.pendingweapon != wp_nochange or player.health <= 0 then
      wi = _PS_WeaponInfo(player.readyweapon)
      if wi is not void then
        P_SetPsprite(player, ps_weapon, wi.downstate)
      end if
      return
    end if

    buttons = 0
    if player.cmd is not void and player.cmd.buttons is not void then
      buttons = player.cmd.buttons
    end if

    if (buttons & buttoncode_t.BT_ATTACK) != 0 then
      if (not player.attackdown) or(player.readyweapon != wp_missile and player.readyweapon != wp_bfg) then
        player.attackdown = true
        P_FireWeapon(player)
        return
      end if
    else
      player.attackdown = false
    end if

    angle =(128 * leveltime) & FINEMASK
    psp.sx = FRACUNIT
    if typeof(finecosine) == "array" and angle >= 0 and angle < len(finecosine) then
      psp.sx = FRACUNIT + FixedMul(player.bob, finecosine[angle])
    end if

    angle = angle &(_PS_HALF_FINEANGLES - 1)
    psp.sy = WEAPONTOP
    if typeof(finesine) == "array" and angle >= 0 and angle < len(finesine) then
      psp.sy = WEAPONTOP + FixedMul(player.bob, finesine[angle])
    end if
  end function

  /*
  * Function: A_ReFire
  * Purpose: Implements the A_ReFire routine for the engine module behavior.
  */
  function A_ReFire(player, psp)
    psp = psp
    if player is void then return end if

    buttons = 0
    if player.cmd is not void and player.cmd.buttons is not void then
      buttons = player.cmd.buttons
    end if

    if (buttons & buttoncode_t.BT_ATTACK) != 0 and player.pendingweapon == wp_nochange and player.health > 0 then
      player.refire = player.refire + 1
      P_FireWeapon(player)
    else
      player.refire = 0
      P_CheckAmmo(player)
    end if
  end function

  /*
  * Function: A_CheckReload
  * Purpose: Loads and prepares data required by the engine module behavior.
  */
  function A_CheckReload(player, psp)
    psp = psp
    if player is void then return end if
    P_CheckAmmo(player)
  end function

  /*
  * Function: A_Lower
  * Purpose: Implements the A_Lower routine for the engine module behavior.
  */
  function A_Lower(player, psp)
    if player is void or psp is void then return end if
    psp.sy = psp.sy + LOWERSPEED

    if psp.sy < WEAPONBOTTOM then
      return
    end if

    if player.playerstate == playerstate_t.PST_DEAD then
      psp.sy = WEAPONBOTTOM
      return
    end if

    if player.health <= 0 then
      psp.sy = WEAPONBOTTOM
      P_SetPsprite(player, ps_weapon, statenum_t.S_NULL)
      P_SetPsprite(player, ps_flash, statenum_t.S_NULL)
      return
    end if

    player.readyweapon = player.pendingweapon
    P_BringUpWeapon(player)
  end function

  /*
  * Function: A_Raise
  * Purpose: Implements the A_Raise routine for the engine module behavior.
  */
  function A_Raise(player, psp)
    if player is void or psp is void then return end if
    psp.sy = psp.sy - RAISESPEED
    if psp.sy > WEAPONTOP then return end if

    psp.sy = WEAPONTOP
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    P_SetPsprite(player, ps_weapon, wi.readystate)
  end function

  /*
  * Function: A_GunFlash
  * Purpose: Implements the A_GunFlash routine for the engine module behavior.
  */
  function A_GunFlash(player, psp)
    psp = psp
    if player is void then return end if
    if typeof(P_SetMobjState) == "function" and player.mo is not void then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK2)
    end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    P_SetPsprite(player, ps_flash, wi.flashstate)
  end function

  /*
  * Function: A_Punch
  * Purpose: Implements the A_Punch routine for the engine module behavior.
  */
  function A_Punch(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if

    damage =((P_Random() % 10) + 1) << 1

    pwi = _PS_PowerIndex(pw_strength)
    if pwi >= 0 and typeof(player.powers) == "array" and pwi < len(player.powers) and player.powers[pwi] then
      damage = damage * 10
    end if

    angle = player.mo.angle
    angle = angle +((P_Random() - P_Random()) << 18)

    slope = 0
    slope = P_AimLineAttack(player.mo, angle, MELEERANGE)
    P_LineAttack(player.mo, angle, MELEERANGE, slope, damage)

    if linetarget is not void then
      _PS_PlaySound(player.mo, sfxenum_t.sfx_punch)
      if typeof(R_PointToAngle2) == "function" then
        player.mo.angle = R_PointToAngle2(player.mo.x, player.mo.y, linetarget.x, linetarget.y)
      end if
    end if
  end function

  /*
  * Function: A_Saw
  * Purpose: Implements the A_Saw routine for the engine module behavior.
  */
  function A_Saw(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if

    damage = 2 *((P_Random() % 10) + 1)
    angle = player.mo.angle
    angle = angle +((P_Random() - P_Random()) << 18)

    slope = 0
    slope = P_AimLineAttack(player.mo, angle, MELEERANGE + 1)
    P_LineAttack(player.mo, angle, MELEERANGE + 1, slope, damage)

    if linetarget is void then
      _PS_PlaySound(player.mo, sfxenum_t.sfx_sawful)
      return
    end if

    _PS_PlaySound(player.mo, sfxenum_t.sfx_sawhit)

    if typeof(R_PointToAngle2) == "function" then
      angle = R_PointToAngle2(player.mo.x, player.mo.y, linetarget.x, linetarget.y)
      delta = angle - player.mo.angle
      if delta > ANG180 then
        if delta <(-_PS_ANG90_DIV20) then
          player.mo.angle = angle + _PS_ANG90_DIV21
        else
          player.mo.angle = player.mo.angle - _PS_ANG90_DIV20
        end if
      else
        if delta > _PS_ANG90_DIV20 then
          player.mo.angle = angle - _PS_ANG90_DIV21
        else
          player.mo.angle = player.mo.angle + _PS_ANG90_DIV20
        end if
      end if
    end if

    if player.mo.flags is void then player.mo.flags = 0 end if

    player.mo.flags = player.mo.flags | 128
  end function

  /*
  * Function: A_FirePistol
  * Purpose: Implements the A_FirePistol routine for the engine module behavior.
  */
  function A_FirePistol(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if

    _PS_PlaySound(player.mo, sfxenum_t.sfx_pistol)
    _PS_DiagFireLog("A_FirePistol ammo=" + _PS_GetAmmoCount(player, wi.ammo))

    if typeof(P_SetMobjState) == "function" then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK2)
    end if
    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 1)

    P_SetPsprite(player, ps_flash, wi.flashstate)

    P_BulletSlope(player.mo)
    P_GunShot(player.mo, player.refire == 0)
  end function

  /*
  * Function: A_FireShotgun
  * Purpose: Implements the A_FireShotgun routine for the engine module behavior.
  */
  function A_FireShotgun(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if

    _PS_PlaySound(player.mo, sfxenum_t.sfx_shotgn)
    _PS_DiagFireLog("A_FireShotgun ammo=" + _PS_GetAmmoCount(player, wi.ammo))
    if typeof(P_SetMobjState) == "function" then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK2)
    end if

    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 1)

    P_SetPsprite(player, ps_flash, wi.flashstate)
    P_BulletSlope(player.mo)

    i = 0
    while i < 7
      P_GunShot(player.mo, false)
      i = i + 1
    end while
  end function

  /*
  * Function: A_FireShotgun2
  * Purpose: Implements the A_FireShotgun2 routine for the engine module behavior.
  */
  function A_FireShotgun2(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if

    _PS_PlaySound(player.mo, sfxenum_t.sfx_dshtgn)
    _PS_DiagFireLog("A_FireShotgun2 ammo=" + _PS_GetAmmoCount(player, wi.ammo))
    if typeof(P_SetMobjState) == "function" then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK2)
    end if

    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 2)
    P_SetPsprite(player, ps_flash, wi.flashstate)
    P_BulletSlope(player.mo)

    i = 0
    while i < 20
      damage = 5 *((P_Random() % 3) + 1)
      angle = player.mo.angle
      angle = angle +((P_Random() - P_Random()) << 19)
      P_LineAttack(player.mo, angle, MISSILERANGE, bulletslope +((P_Random() - P_Random()) << 5), damage)
      i = i + 1
    end while
  end function

  /*
  * Function: A_FireCGun
  * Purpose: Implements the A_FireCGun routine for the engine module behavior.
  */
  function A_FireCGun(player, psp)
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if

    _PS_PlaySound(player.mo, sfxenum_t.sfx_pistol)
    _PS_DiagFireLog("A_FireCGun ammo=" + _PS_GetAmmoCount(player, wi.ammo))

    if _PS_GetAmmoCount(player, wi.ammo) <= 0 then
      return
    end if

    if typeof(P_SetMobjState) == "function" then
      P_SetMobjState(player.mo, statenum_t.S_PLAY_ATK2)
    end if
    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 1)

    fl = Info_StateIndex(wi.flashstate)
    if psp is not void and psp.state is not void then
      cs = _PS_StateObjectIndex(psp.state)
      c1 = Info_StateIndex(statenum_t.S_CHAIN1)
      if cs >= 0 and c1 >= 0 then
        fl = fl + cs - c1
      end if
    end if
    P_SetPsprite(player, ps_flash, fl)

    P_BulletSlope(player.mo)
    P_GunShot(player.mo, player.refire == 0)
  end function

  /*
  * Function: A_FireMissile
  * Purpose: Implements the A_FireMissile routine for the engine module behavior.
  */
  function A_FireMissile(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 1)
    if typeof(P_SpawnPlayerMissile) == "function" then
      P_SpawnPlayerMissile(player.mo, mobjtype_t.MT_ROCKET)
    end if
  end function

  /*
  * Function: A_FirePlasma
  * Purpose: Implements the A_FirePlasma routine for the engine module behavior.
  */
  function A_FirePlasma(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - 1)

    fidx = Info_StateIndex(wi.flashstate)
    P_SetPsprite(player, ps_flash, fidx +(P_Random() & 1))

    if typeof(P_SpawnPlayerMissile) == "function" then
      P_SpawnPlayerMissile(player.mo, mobjtype_t.MT_PLASMA)
    end if
  end function

  /*
  * Function: A_FireBFG
  * Purpose: Implements the A_FireBFG routine for the engine module behavior.
  */
  function A_FireBFG(player, psp)
    psp = psp
    if player is void or player.mo is void then return end if
    wi = _PS_WeaponInfo(player.readyweapon)
    if wi is void then return end if
    _PS_SetAmmoCount(player, wi.ammo, _PS_GetAmmoCount(player, wi.ammo) - BFGCELLS)
    if typeof(P_SpawnPlayerMissile) == "function" then
      P_SpawnPlayerMissile(player.mo, mobjtype_t.MT_BFG)
    end if
  end function

  /*
  * Function: A_BFGsound
  * Purpose: Implements the A_BFGsound routine for the engine module behavior.
  */
  function A_BFGsound(player, psp)
    psp = psp
    if player is void then return end if
    _PS_PlaySound(player.mo, sfxenum_t.sfx_bfg)
  end function

  /*
  * Function: A_BFGSpray
  * Purpose: Implements the A_BFGSpray routine for the engine module behavior.
  */
  function A_BFGSpray(mo)
    if mo is void then return end if
    if mo.target is void then return end if

    i = 0
    while i < 40
      an = mo.angle -(ANG90 >> 1) + _PS_ANG90_DIV40 * i

      P_AimLineAttack(mo.target, an, 16 * 64 * FRACUNIT)

      if linetarget is void then
        i = i + 1
        continue
      end if

      if typeof(P_SpawnMobj) == "function" then
        P_SpawnMobj(linetarget.x, linetarget.y, linetarget.z +(linetarget.height >> 2), mobjtype_t.MT_EXTRABFG)
      end if

      damage = 0
      j = 0
      while j < 15
        damage = damage +((P_Random() & 7) + 1)
        j = j + 1
      end while

      if typeof(P_DamageMobj) == "function" then
        P_DamageMobj(linetarget, mo.target, mo.target, damage)
      end if

      i = i + 1
    end while
  end function

  /*
  * Function: A_Light0
  * Purpose: Implements the A_Light0 routine for the engine module behavior.
  */
  function A_Light0(player, psp)
    psp = psp
    if player is void then return end if
    player.extralight = 0
  end function

  /*
  * Function: A_Light1
  * Purpose: Implements the A_Light1 routine for the engine module behavior.
  */
  function A_Light1(player, psp)
    psp = psp
    if player is void then return end if
    player.extralight = 1
  end function

  /*
  * Function: A_Light2
  * Purpose: Implements the A_Light2 routine for the engine module behavior.
  */
  function A_Light2(player, psp)
    psp = psp
    if player is void then return end if
    player.extralight = 2
  end function

  /*
  * Function: P_BulletSlope
  * Purpose: Implements the P_BulletSlope routine for the gameplay and world simulation.
  */
  function P_BulletSlope(mo)
    global bulletslope

    if mo is void then
      bulletslope = 0
      return
    end if

    an = mo.angle
    bulletslope = P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT)
    _PS_DiagFireLog("P_BulletSlope slope=" + bulletslope + " target=" +(linetarget is not void))

    if linetarget is void then
      an = an +(1 << 26)
      bulletslope = P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT)
      if linetarget is void then
        an = an -(2 << 26)
        bulletslope = P_AimLineAttack(mo, an, 16 * 64 * FRACUNIT)
      end if
    end if
  end function

  /*
  * Function: P_GunShot
  * Purpose: Implements the P_GunShot routine for the gameplay and world simulation.
  */
  function P_GunShot(mo, accurate)
    if mo is void then return end if
    damage = 5 *((P_Random() % 3) + 1)
    angle = mo.angle

    if not accurate then
      angle = angle +((P_Random() - P_Random()) << 18)
    end if

    _PS_DiagFireLog("P_GunShot dmg=" + damage + " accurate=" + accurate + " slope=" + bulletslope)
    P_LineAttack(mo, angle, MISSILERANGE, bulletslope, damage)
  end function



