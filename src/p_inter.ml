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

  Script: p_inter.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import doomdef
import dstrings
import sounds
import doomstat
import m_argv
import m_random
import i_system
import am_map
import tables
import p_local
import p_mobj
import p_pspr
import r_main
import d_player
import info
import s_sound

/*
* Function: P_GivePower
* Purpose: Implements the P_GivePower routine for the gameplay and world simulation.
*/
function P_GivePower(player, power)
  if player is void then return false end if
  pi = _PI_PowerIndex(power)
  if pi < 0 then return false end if
  if typeof(pi) != "int" then
    pin = toNumber(pi)
    if typeof(pin) != "int" then return false end if
    pi = pin
  end if
  if typeof(player.powers) != "array" and typeof(player.powers) != "list" then return false end if
  if pi >= len(player.powers) then return false end if

  if power == pw_invulnerability then
    player.powers[pi] = INVULNTICS
    return true
  end if

  if power == pw_invisibility then
    player.powers[pi] = INVISTICS
    if player.mo is not void then
      player.mo.flags = player.mo.flags | mobjflag_t.MF_SHADOW
    end if
    return true
  end if

  if power == pw_infrared then
    player.powers[pi] = INFRATICS
    return true
  end if

  if power == pw_ironfeet then
    player.powers[pi] = IRONTICS
    return true
  end if

  if power == pw_strength then
    P_GiveBody(player, 100)
    player.powers[pi] = 1
    return true
  end if

  if player.powers[pi] then return false end if
  player.powers[pi] = 1
  return true
end function

const BONUSADD = 6

maxammo =[200, 50, 300, 50]
clipammo =[10, 4, 20, 1]
_piDiagHitInit = false
_piDiagHit = false
_piDiagHitCount = 0

/*
* Function: _PI_DiagHitEnabled
* Purpose: Implements the _PI_DiagHitEnabled routine for the internal module support.
*/
function _PI_DiagHitEnabled()
  global _piDiagHitInit
  global _piDiagHit
  if _piDiagHitInit then return _piDiagHit end if
  _piDiagHitInit = true
  _piDiagHit = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diaghit") or M_CheckParm("--diaghit") then
      _piDiagHit = true
    end if
  end if
  if _piDiagHit then
    print "P_Inter: -diaghit enabled"
  end if
  return _piDiagHit
end function

/*
* Function: _PI_DiagHitLog
* Purpose: Implements the _PI_DiagHitLog routine for the internal module support.
*/
function inline _PI_DiagHitLog(msg)
  global _piDiagHitCount
  if not _PI_DiagHitEnabled() then return end if
  _piDiagHitCount = _piDiagHitCount + 1
  if _piDiagHitCount <= 80 or(_piDiagHitCount & 127) == 0 then
    print "P_DamageMobj: " + msg
  end if
end function

/*
* Function: _PI_AmmoIndex
* Purpose: Implements the _PI_AmmoIndex routine for the internal module support.
*/
function inline _PI_AmmoIndex(a)
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
* Function: _PI_WeaponIndex
* Purpose: Implements the _PI_WeaponIndex routine for the internal module support.
*/
function _PI_WeaponIndex(w)
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
* Function: _PI_PowerIndex
* Purpose: Implements the _PI_PowerIndex routine for the internal module support.
*/
function _PI_PowerIndex(pw)
  if typeof(pw) == "int" then
    if pw >= 0 and pw < 6 then return pw end if
    return -1
  end if
  n = toNumber(pw)
  if typeof(n) == "int" then
    if n >= 0 and n < 6 then return n end if
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
* Function: _PI_CardIndex
* Purpose: Implements the _PI_CardIndex routine for the internal module support.
*/
function _PI_CardIndex(card)
  if typeof(card) == "int" then
    if card >= 0 and card < NUMCARDS then return card end if
    return -1
  end if

  n = toNumber(card)
  if typeof(n) == "int" then
    if n >= 0 and n < NUMCARDS then return n end if
    return -1
  else if typeof(n) == "float" then
    ni = std.math.floor(n)
    if ni >= 0 and ni < NUMCARDS then return ni end if
    return -1
  end if

  if card == it_bluecard then return 0 end if
  if card == it_yellowcard then return 1 end if
  if card == it_redcard then return 2 end if
  if card == it_blueskull then return 3 end if
  if card == it_yellowskull then return 4 end if
  if card == it_redskull then return 5 end if
  return -1
end function

/*
* Function: _PI_HasCard
* Purpose: Implements the _PI_HasCard routine for the internal module support.
*/
function inline _PI_HasCard(player, card)
  if player is void then return false end if
  if typeof(player.cards) != "array" and typeof(player.cards) != "list" then return false end if
  ci = _PI_CardIndex(card)
  if ci < 0 or ci >= len(player.cards) then return false end if
  return player.cards[ci]
end function

/*
* Function: _PI_IDiv
* Purpose: Implements the _PI_IDiv routine for the internal module support.
*/
function inline _PI_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _PI_WeaponInfo
* Purpose: Implements the _PI_WeaponInfo routine for the internal module support.
*/
function inline _PI_WeaponInfo(weapon)
  wi = _PI_WeaponIndex(weapon)
  if wi < 0 then return void end if
  if typeof(weaponinfo) != "array" then return void end if
  if wi >= len(weaponinfo) then return void end if
  return weaponinfo[wi]
end function

/*
* Function: _PI_HasWeapon
* Purpose: Implements the _PI_HasWeapon routine for the internal module support.
*/
function inline _PI_HasWeapon(player, weapon)
  if player is void then return false end if
  wi = _PI_WeaponIndex(weapon)
  if wi < 0 then return false end if
  if typeof(player.weaponowned) != "array" and typeof(player.weaponowned) != "list" then return false end if
  if wi >= len(player.weaponowned) then return false end if
  return player.weaponowned[wi]
end function

/*
* Function: _PI_PlayerIndex
* Purpose: Implements the _PI_PlayerIndex routine for the internal module support.
*/
function _PI_PlayerIndex(player)
  if player is void then return -1 end if
  if typeof(players) != "array" then return -1 end if
  if typeof(player.mo) == "struct" then
    i = 0
    while i < len(players)
      pi = players[i]
      if typeof(pi) == "struct" and typeof(pi.mo) == "struct" and pi.mo == player.mo then return i end if
      i = i + 1
    end while
  end if
  i = 0
  while i < len(players)
    pi = players[i]
    if pi == player then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _PI_PlayerIndexForThing
* Purpose: Resolves player slot by player struct first, then by owning mobj.
*/
function _PI_PlayerIndexForThing(player, thing)
  if thing is not void and typeof(players) == "array" then
    i = 0
    while i < len(players)
      pi = players[i]
      if typeof(pi) == "struct" and typeof(pi.mo) == "struct" and pi.mo == thing then
        return i
      end if
      i = i + 1
    end while
  end if
  idx = _PI_PlayerIndex(player)
  if idx >= 0 then return idx end if
  if thing is void then return -1 end if
  if typeof(players) != "array" then return -1 end if
  i = 0
  while i < len(players)
    pi = players[i]
    if typeof(pi) == "struct" and typeof(pi.mo) == "struct" and pi.mo == thing then
      return i
    end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _PI_CommitTouchedPlayer
* Purpose: Writes pickup-mutated player state back to global slot and touching mobj.
*/
function inline _PI_CommitTouchedPlayer(toucher, player, pidx)
  if typeof(player) != "struct" then return end if
  if typeof(players) == "array" and pidx >= 0 and pidx < len(players) then
    players[pidx] = player
  end if
  if typeof(toucher) == "struct" then
    toucher.player = player
  end if
end function

/*
* Function: P_GiveAmmo
* Purpose: Implements the P_GiveAmmo routine for the gameplay and world simulation.
*/
function P_GiveAmmo(player, ammo, num)
  if player is void then return false end if
  ai = _PI_AmmoIndex(ammo)
  if ai < 0 then return false end if

  if typeof(player.ammo) != "array" or typeof(player.maxammo) != "array" then
    return false
  end if
  if ai >= len(player.ammo) or ai >= len(player.maxammo) or ai >= len(clipammo) then
    return false
  end if

  if player.ammo[ai] == player.maxammo[ai] then return false end if

  if num != 0 then
    num = num * clipammo[ai]
  else
    num = clipammo[ai] >> 1
  end if

  if gameskill == sk_baby or gameskill == sk_nightmare then
    num = num << 1
  end if

  oldammo = player.ammo[ai]
  player.ammo[ai] = player.ammo[ai] + num
  if player.ammo[ai] > player.maxammo[ai] then
    player.ammo[ai] = player.maxammo[ai]
  end if

  if oldammo != 0 then return true end if

  if ammo == am_clip then
    if player.readyweapon == wp_fist then
      if _PI_HasWeapon(player, wp_chaingun) then
        player.pendingweapon = wp_chaingun
      else
        player.pendingweapon = wp_pistol
      end if
    end if
  else if ammo == am_shell then
    if player.readyweapon == wp_fist or player.readyweapon == wp_pistol then
      if _PI_HasWeapon(player, wp_shotgun) then
        player.pendingweapon = wp_shotgun
      end if
    end if
  else if ammo == am_cell then
    if player.readyweapon == wp_fist or player.readyweapon == wp_pistol then
      if _PI_HasWeapon(player, wp_plasma) then
        player.pendingweapon = wp_plasma
      end if
    end if
  else if ammo == am_misl then
    if player.readyweapon == wp_fist then
      if _PI_HasWeapon(player, wp_missile) then
        player.pendingweapon = wp_missile
      end if
    end if
  end if
  return true
end function

/*
* Function: P_GiveWeapon
* Purpose: Implements the P_GiveWeapon routine for the gameplay and world simulation.
*/
function P_GiveWeapon(player, weapon, dropped)
  if player is void then return false end if
  wi = _PI_WeaponIndex(weapon)
  if wi < 0 then return false end if
  if typeof(player.weaponowned) != "array" or wi >= len(player.weaponowned) then return false end if

  winfo = _PI_WeaponInfo(weapon)
  if winfo is void then return false end if

  if netgame and(deathmatch != 2) and(not dropped) then
    if player.weaponowned[wi] then
      return false
    end if

    player.bonuscount = player.bonuscount + BONUSADD
    player.weaponowned[wi] = true

    if deathmatch then
      P_GiveAmmo(player, winfo.ammo, 5)
    else
      P_GiveAmmo(player, winfo.ammo, 2)
    end if
    player.pendingweapon = weapon

    if player == players[consoleplayer] and typeof(S_StartSound) == "function" then
      S_StartSound(void, sfxenum_t.sfx_wpnup)
    end if
    return false
  end if

  gaveammo = false
  if winfo.ammo != am_noammo then
    if dropped then
      gaveammo = P_GiveAmmo(player, winfo.ammo, 1)
    else
      gaveammo = P_GiveAmmo(player, winfo.ammo, 2)
    end if
  end if

  gaveweapon = false
  if not player.weaponowned[wi] then
    gaveweapon = true
    player.weaponowned[wi] = true
    player.pendingweapon = weapon
  end if

  return gaveweapon or gaveammo
end function

/*
* Function: P_GiveBody
* Purpose: Implements the P_GiveBody routine for the gameplay and world simulation.
*/
function P_GiveBody(player, num)
  if player is void then return false end if
  if player.health >= MAXHEALTH then return false end if
  player.health = player.health + num
  if player.health > MAXHEALTH then player.health = MAXHEALTH end if
  if player.mo is not void then player.mo.health = player.health end if
  return true
end function

/*
* Function: P_GiveArmor
* Purpose: Implements the P_GiveArmor routine for the gameplay and world simulation.
*/
function P_GiveArmor(player, armortype)
  if player is void then return false end if
  hits = armortype * 100
  if player.armorpoints >= hits then return false end if
  player.armortype = armortype
  player.armorpoints = hits
  return true
end function

/*
* Function: P_GiveCard
* Purpose: Implements the P_GiveCard routine for the gameplay and world simulation.
*/
function P_GiveCard(player, card)
  if player is void then return false end if
  if typeof(player.cards) != "array" and typeof(player.cards) != "list" then return false end if
  ci = _PI_CardIndex(card)
  if ci < 0 or ci >= len(player.cards) then return false end if
  if player.cards[ci] then return false end if
  player.cards[ci] = true
  player.bonuscount = BONUSADD
  return true
end function

/*
* Function: P_TouchSpecialThing
* Purpose: Implements the P_TouchSpecialThing routine for the gameplay and world simulation.
*/
function P_TouchSpecialThing(special, toucher)
  if special is void or toucher is void then return end if

  delta = special.z - toucher.z
  if delta > toucher.height or delta < -8 * FRACUNIT then
    return
  end if

  pidx = _PI_PlayerIndexForThing(toucher.player, toucher)
  player = toucher.player
  if typeof(players) == "array" and pidx >= 0 and pidx < len(players) and typeof(players[pidx]) == "struct" then
    player = players[pidx]
  end if
  if player is void then return end if

  if toucher.health <= 0 then return end if

  sound = sfxenum_t.sfx_itemup
  spr = special.sprite

  if spr == spritenum_t.SPR_ARM1 then
    if not P_GiveArmor(player, 1) then return end if
    player.message = GOTARMOR
  else if spr == spritenum_t.SPR_ARM2 then
    if not P_GiveArmor(player, 2) then return end if
    player.message = GOTMEGA

  else if spr == spritenum_t.SPR_BON1 then
    player.health = player.health + 1
    if player.health > 200 then player.health = 200 end if
    if player.mo is not void then player.mo.health = player.health end if
    player.message = GOTHTHBONUS
  else if spr == spritenum_t.SPR_BON2 then
    player.armorpoints = player.armorpoints + 1
    if player.armorpoints > 200 then player.armorpoints = 200 end if
    if not player.armortype then player.armortype = 1 end if
    player.message = GOTARMBONUS
  else if spr == spritenum_t.SPR_SOUL then
    player.health = player.health + 100
    if player.health > 200 then player.health = 200 end if
    if player.mo is not void then player.mo.health = player.health end if
    player.message = GOTSUPER
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_MEGA then
    if gamemode != commercial then return end if
    player.health = 200
    if player.mo is not void then player.mo.health = player.health end if
    P_GiveArmor(player, 2)
    player.message = GOTMSPHERE
    sound = sfxenum_t.sfx_getpow

  else if spr == spritenum_t.SPR_BKEY then
    if not _PI_HasCard(player, it_bluecard) then
      player.message = GOTBLUECARD
    end if
    P_GiveCard(player, it_bluecard)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if
  else if spr == spritenum_t.SPR_YKEY then
    if not _PI_HasCard(player, it_yellowcard) then
      player.message = GOTYELWCARD
    end if
    P_GiveCard(player, it_yellowcard)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if
  else if spr == spritenum_t.SPR_RKEY then
    if not _PI_HasCard(player, it_redcard) then
      player.message = GOTREDCARD
    end if
    P_GiveCard(player, it_redcard)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if
  else if spr == spritenum_t.SPR_BSKU then
    if not _PI_HasCard(player, it_blueskull) then
      player.message = GOTBLUESKUL
    end if
    P_GiveCard(player, it_blueskull)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if
  else if spr == spritenum_t.SPR_YSKU then
    if not _PI_HasCard(player, it_yellowskull) then
      player.message = GOTYELWSKUL
    end if
    P_GiveCard(player, it_yellowskull)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if
  else if spr == spritenum_t.SPR_RSKU then
    if not _PI_HasCard(player, it_redskull) then
      player.message = GOTREDSKULL
    end if
    P_GiveCard(player, it_redskull)
    if netgame then
      _PI_CommitTouchedPlayer(toucher, player, pidx)
      return
    end if

  else if spr == spritenum_t.SPR_STIM then
    if not P_GiveBody(player, 10) then return end if
    player.message = GOTSTIM
  else if spr == spritenum_t.SPR_MEDI then
    if not P_GiveBody(player, 25) then return end if
    if player.health < 25 then
      player.message = GOTMEDINEED
    else
      player.message = GOTMEDIKIT
    end if

  else if spr == spritenum_t.SPR_PINV then
    if not P_GivePower(player, pw_invulnerability) then return end if
    player.message = GOTINVUL
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_PSTR then
    if not P_GivePower(player, pw_strength) then return end if
    player.message = GOTBERSERK
    if player.readyweapon != wp_fist then
      player.pendingweapon = wp_fist
    end if
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_PINS then
    if not P_GivePower(player, pw_invisibility) then return end if
    player.message = GOTINVIS
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_SUIT then
    if not P_GivePower(player, pw_ironfeet) then return end if
    player.message = GOTSUIT
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_PMAP then
    if not P_GivePower(player, pw_allmap) then return end if
    player.message = GOTMAP
    sound = sfxenum_t.sfx_getpow
  else if spr == spritenum_t.SPR_PVIS then
    if not P_GivePower(player, pw_infrared) then return end if
    player.message = GOTVISOR
    sound = sfxenum_t.sfx_getpow

  else if spr == spritenum_t.SPR_CLIP then
    if (special.flags & mobjflag_t.MF_DROPPED) != 0 then
      if not P_GiveAmmo(player, am_clip, 0) then return end if
    else
      if not P_GiveAmmo(player, am_clip, 1) then return end if
    end if
    player.message = GOTCLIP
  else if spr == spritenum_t.SPR_AMMO then
    if not P_GiveAmmo(player, am_clip, 5) then return end if
    player.message = GOTCLIPBOX
  else if spr == spritenum_t.SPR_ROCK then
    if not P_GiveAmmo(player, am_misl, 1) then return end if
    player.message = GOTROCKET
  else if spr == spritenum_t.SPR_BROK then
    if not P_GiveAmmo(player, am_misl, 5) then return end if
    player.message = GOTROCKBOX
  else if spr == spritenum_t.SPR_CELL then
    if not P_GiveAmmo(player, am_cell, 1) then return end if
    player.message = GOTCELL
  else if spr == spritenum_t.SPR_CELP then
    if not P_GiveAmmo(player, am_cell, 5) then return end if
    player.message = GOTCELLBOX
  else if spr == spritenum_t.SPR_SHEL then
    if not P_GiveAmmo(player, am_shell, 1) then return end if
    player.message = GOTSHELLS
  else if spr == spritenum_t.SPR_SBOX then
    if not P_GiveAmmo(player, am_shell, 5) then return end if
    player.message = GOTSHELLBOX
  else if spr == spritenum_t.SPR_BPAK then
    if not player.backpack then
      if typeof(player.maxammo) == "array" then
        for i = 0 to NUMAMMO - 1
          if i < len(player.maxammo) then
            player.maxammo[i] = player.maxammo[i] * 2
          end if
        end for
      end if
      player.backpack = true
    end if
    for i = 0 to NUMAMMO - 1
      P_GiveAmmo(player, i, 1)
    end for
    player.message = GOTBACKPACK

  else if spr == spritenum_t.SPR_BFUG then
    if not P_GiveWeapon(player, wp_bfg, false) then return end if
    player.message = GOTBFG9000
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_MGUN then
    if not P_GiveWeapon(player, wp_chaingun,(special.flags & mobjflag_t.MF_DROPPED) != 0) then return end if
    player.message = GOTCHAINGUN
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_CSAW then
    if not P_GiveWeapon(player, wp_chainsaw, false) then return end if
    player.message = GOTCHAINSAW
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_LAUN then
    if not P_GiveWeapon(player, wp_missile, false) then return end if
    player.message = GOTLAUNCHER
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_PLAS then
    if not P_GiveWeapon(player, wp_plasma, false) then return end if
    player.message = GOTPLASMA
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_SHOT then
    if not P_GiveWeapon(player, wp_shotgun,(special.flags & mobjflag_t.MF_DROPPED) != 0) then return end if
    player.message = GOTSHOTGUN
    sound = sfxenum_t.sfx_wpnup
  else if spr == spritenum_t.SPR_SGN2 then
    if not P_GiveWeapon(player, wp_supershotgun,(special.flags & mobjflag_t.MF_DROPPED) != 0) then return end if
    player.message = GOTSHOTGUN2
    sound = sfxenum_t.sfx_wpnup
  else
    if typeof(I_Error) == "function" then
      I_Error("P_SpecialThing: Unknown gettable thing")
    end if
    return
  end if

  if (special.flags & mobjflag_t.MF_COUNTITEM) != 0 then
    player.itemcount = player.itemcount + 1
  end if
  _PI_CommitTouchedPlayer(toucher, player, pidx)
  P_RemoveMobj(special)
  player.bonuscount = player.bonuscount + BONUSADD
  _PI_CommitTouchedPlayer(toucher, player, pidx)
  if typeof(S_StartSound) == "function" then
    sndOrigin = void
    if typeof(toucher) == "struct" then sndOrigin = toucher end if
    if typeof(player) == "struct" and typeof(player.mo) == "struct" then sndOrigin = player.mo end if
    S_StartSound(sndOrigin, sound)
  end if
end function

/*
* Function: P_KillMobj
* Purpose: Implements the P_KillMobj routine for the gameplay and world simulation.
*/
function P_KillMobj(source, target)
  if target is void then return end if

  target.flags = target.flags &(~(mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_FLOAT | mobjflag_t.MF_SKULLFLY))
  if target.type != mobjtype_t.MT_SKULL then
    target.flags = target.flags &(~mobjflag_t.MF_NOGRAVITY)
  end if
  target.flags = target.flags | mobjflag_t.MF_CORPSE | mobjflag_t.MF_DROPOFF
  target.height = target.height >> 2

  if source is not void and source.player is not void then
    if (target.flags & mobjflag_t.MF_COUNTKILL) != 0 then
      source.player.killcount = source.player.killcount + 1
    end if
    if target.player is not void then
      pidx = _PI_PlayerIndex(target.player)
      if pidx >= 0 and typeof(source.player.frags) == "array" and pidx < len(source.player.frags) then
        source.player.frags[pidx] = source.player.frags[pidx] + 1
      end if
    end if
  else if (not netgame) and((target.flags & mobjflag_t.MF_COUNTKILL) != 0) then
    if typeof(players) == "array" and len(players) > 0 and typeof(players[0]) == "struct" then
      p0 = players[0]
      p0.killcount = p0.killcount + 1
      players[0] = p0
    end if
  end if

  if target.player is not void then
    if source is void then
      pidx = _PI_PlayerIndex(target.player)
      if pidx >= 0 and typeof(target.player.frags) == "array" and pidx < len(target.player.frags) then
        target.player.frags[pidx] = target.player.frags[pidx] + 1
      end if
    end if
    target.flags = target.flags &(~mobjflag_t.MF_SOLID)
    target.player.playerstate = playerstate_t.PST_DEAD

    pidx = _PI_PlayerIndex(target.player)
    if pidx >= 0 and typeof(players) == "array" and pidx < len(players) and typeof(players[pidx]) == "struct" then
      pp = players[pidx]
      pp.playerstate = playerstate_t.PST_DEAD
      pp.mo = target
      players[pidx] = pp
      target.player = pp
    end if
    if typeof(P_DropWeapon) == "function" then
      P_DropWeapon(target.player)
    end if
    if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and target.player == players[consoleplayer] and automapactive and typeof(AM_Stop) == "function" then
      AM_Stop()
    end if
  end if

  if target.info is not void then
    if target.health < -target.info.spawnhealth and target.info.xdeathstate is not void and target.info.xdeathstate != statenum_t.S_NULL then
      P_SetMobjState(target, target.info.xdeathstate)
    else
      P_SetMobjState(target, target.info.deathstate)
    end if
  end if

  if typeof(target.tics) != "int" then target.tics = 1 end if
  target.tics = target.tics -(P_Random() & 3)
  if target.tics < 1 then target.tics = 1 end if

  item = void
  if target.type == mobjtype_t.MT_WOLFSS or target.type == mobjtype_t.MT_POSSESSED then
    item = mobjtype_t.MT_CLIP
  else if target.type == mobjtype_t.MT_SHOTGUY then
    item = mobjtype_t.MT_SHOTGUN
  else if target.type == mobjtype_t.MT_CHAINGUY then
    item = mobjtype_t.MT_CHAINGUN
  else
    return
  end if

  mo = P_SpawnMobj(target.x, target.y, ONFLOORZ, item)
  if mo is not void then
    mo.flags = mo.flags | mobjflag_t.MF_DROPPED
  end if
end function

/*
* Function: P_DamageMobj
* Purpose: Implements the P_DamageMobj routine for the gameplay and world simulation.
*/
function P_DamageMobj(target, inflictor, source, damage)
  if target is void then return end if
  if (target.flags & mobjflag_t.MF_SHOOTABLE) == 0 then return end if
  if target.health <= 0 then return end if

  if (target.flags & mobjflag_t.MF_SKULLFLY) != 0 then
    target.momx = 0
    target.momy = 0
    target.momz = 0
  end if

  player = target.player
  if player is not void and gameskill == sk_baby then
    damage = damage >> 1
  end if

  if inflictor is not void and(target.flags & mobjflag_t.MF_NOCLIP) == 0 then
    canthrust = true
    if source is not void and source.player is not void and source.player.readyweapon == wp_chainsaw then
      canthrust = false
    end if
    if canthrust and target.info is not void and target.info.mass is not void and target.info.mass != 0 then
      ang = 0
      if typeof(R_PointToAngle2) == "function" then
        ang = R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y)
      end if

      thrust = _PI_IDiv(damage *(FRACUNIT >> 3) * 100, target.info.mass)
      if damage < 40 and damage > target.health and target.z - inflictor.z > 64 * FRACUNIT and(P_Random() & 1) != 0 then
        ang = ang + ANG180
        thrust = thrust * 4
      end if

      if typeof(finecosine) == "array" and typeof(finesine) == "array" and len(finecosine) > 0 and len(finesine) > 0 then
        aidx =(ang >> ANGLETOFINESHIFT) & FINEMASK
        if aidx >= len(finecosine) then aidx = aidx % len(finecosine) end if
        if aidx >= len(finesine) then aidx = aidx % len(finesine) end if
        target.momx = target.momx + FixedMul(thrust, finecosine[aidx])
        target.momy = target.momy + FixedMul(thrust, finesine[aidx])
      end if
    end if
  end if

  if player is not void then

    if target.subsector is not void and target.subsector.sector is not void and target.subsector.sector.special == 11 and damage >= target.health then
      damage = target.health - 1
    end if

    pinv = _PI_PowerIndex(pw_invulnerability)
    if damage < 1000 and(((player.cheats & 2) != 0) or(pinv >= 0 and typeof(player.powers) == "array" and pinv < len(player.powers) and player.powers[pinv])) then
      return
    end if

    if player.armortype then
      saved = 0
      if player.armortype == 1 then
        saved = _PI_IDiv(damage, 3)
      else
        saved = _PI_IDiv(damage, 2)
      end if

      if player.armorpoints <= saved then
        saved = player.armorpoints
        player.armortype = 0
      end if
      player.armorpoints = player.armorpoints - saved
      damage = damage - saved
    end if

    player.health = player.health - damage
    if player.health < 0 then player.health = 0 end if
    player.attacker = source
    player.damagecount = player.damagecount + damage
    if player.damagecount > 100 then player.damagecount = 100 end if
  end if

  target.health = target.health - damage
  srcp = 0
  if source is not void and source.player is not void then srcp = 1 end if
  tgtp = 0
  if player is not void then tgtp = 1 end if
  srct = -1
  if source is not void and typeof(source.type) == "int" then srct = source.type end if
  tgtt = -1
  if typeof(target.type) == "int" then tgtt = target.type end if
  _PI_DiagHitLog("dmg=" + damage + " srcp=" + srcp + " tgtp=" + tgtp + " srct=" + srct + " tgtt=" + tgtt + " hp=" + target.health)
  if target.health <= 0 then
    P_KillMobj(source, target)
    return
  end if

  if target.info is not void and target.info.painchance is not void then
    if (P_Random() < target.info.painchance) and((target.flags & mobjflag_t.MF_SKULLFLY) == 0) then
      target.flags = target.flags | mobjflag_t.MF_JUSTHIT
      if target.info.painstate is not void and target.info.painstate != statenum_t.S_NULL then
        P_SetMobjState(target, target.info.painstate)
      end if
    end if
  end if

  target.reactiontime = 0

  if source is not void and source != target and target.info is not void then
    if ((not target.threshold) or target.type == mobjtype_t.MT_VILE) and source.type != mobjtype_t.MT_VILE then
      target.target = source
      target.threshold = BASETHRESHOLD
      spawnstate = Info_StateAt(target.info.spawnstate)
      if target.state == spawnstate and target.info.seestate is not void and target.info.seestate != statenum_t.S_NULL then
        P_SetMobjState(target, target.info.seestate)
      end if
    end if
  end if
end function



