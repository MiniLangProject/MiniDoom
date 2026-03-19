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

  Script: p_saveg.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import i_system
import z_zone
import p_local
import doomstat
import r_state
import d_player
import d_ticcmd
import p_mobj
import p_tick
import p_floor
import p_doors
import p_plats
import p_ceilng
import p_lights
import p_switch
import info
import r_main

savebuffer = void
save_p = 0

/*
* Function: _PSave_EnsureBuffer
* Purpose: Implements the _PSave_EnsureBuffer routine for the internal module support.
*/
function _PSave_EnsureBuffer(size)
  global savebuffer
  global save_p

  if typeof(savebuffer) != "bytes" or len(savebuffer) < size then
    savebuffer = bytes(size, 0)
  end if
  save_p = 0
end function

/*
* Function: _PSV_Ensure
* Purpose: Implements the _PSV_Ensure routine for the internal module support.
*/
function _PSV_Ensure(extra)
  global savebuffer

  if typeof(savebuffer) != "bytes" then
    savebuffer = bytes(0, 0)
  end if

  need = save_p + extra
  if need <= len(savebuffer) then return end if

  newlen = len(savebuffer)
  if newlen < 64 then newlen = 64 end if
  while newlen < need
    newlen = newlen * 2
  end while

  nb = bytes(newlen, 0)
  i = 0
  while i < len(savebuffer)
    nb[i] = savebuffer[i]
    i = i + 1
  end while
  savebuffer = nb
end function

/*
* Function: _PSV_WriteU8
* Purpose: Implements the _PSV_WriteU8 routine for the internal module support.
*/
function _PSV_WriteU8(v)
  global save_p
  _PSV_Ensure(1)
  savebuffer[save_p] = v & 255
  save_p = save_p + 1
end function

/*
* Function: _PSV_WriteBool
* Purpose: Implements the _PSV_WriteBool routine for the internal module support.
*/
function _PSV_WriteBool(v)
  if v then _PSV_WriteU8(1) else _PSV_WriteU8(0) end if
end function

/*
* Function: _PSV_WriteS32
* Purpose: Implements the _PSV_WriteS32 routine for the internal module support.
*/
function _PSV_WriteS32(v)
  _PSV_WriteU8(v & 255)
  _PSV_WriteU8((v >> 8) & 255)
  _PSV_WriteU8((v >> 16) & 255)
  _PSV_WriteU8((v >> 24) & 255)
end function

/*
* Function: _PSV_WriteTag
* Purpose: Implements the _PSV_WriteTag routine for the internal module support.
*/
function _PSV_WriteTag(tag)
  b = bytes(tag)
  i = 0
  while i < 4
    c = 0
    if i < len(b) then c = b[i] end if
    _PSV_WriteU8(c)
    i = i + 1
  end while
end function

/*
* Function: _PSV_WriteFixedString
* Purpose: Implements the _PSV_WriteFixedString routine for the internal module support.
*/
function _PSV_WriteFixedString(s, width)
  b = bytes(s)
  i = 0
  while i < width
    c = 0
    if i < len(b) then c = b[i] end if
    _PSV_WriteU8(c)
    i = i + 1
  end while
end function

/*
* Function: _PSV_ReadU8
* Purpose: Implements the _PSV_ReadU8 routine for the internal module support.
*/
function _PSV_ReadU8()
  global save_p
  if typeof(savebuffer) != "bytes" or save_p < 0 or save_p >= len(savebuffer) then
    save_p = save_p + 1
    return 0
  end if
  v = savebuffer[save_p]
  save_p = save_p + 1
  return v
end function

/*
* Function: _PSV_ReadBool
* Purpose: Implements the _PSV_ReadBool routine for the internal module support.
*/
function _PSV_ReadBool()
  return _PSV_ReadU8() != 0
end function

/*
* Function: _PSV_ReadS32
* Purpose: Implements the _PSV_ReadS32 routine for the internal module support.
*/
function _PSV_ReadS32()
  b0 = _PSV_ReadU8()
  b1 = _PSV_ReadU8()
  b2 = _PSV_ReadU8()
  b3 = _PSV_ReadU8()
  v = b0 |(b1 << 8) |(b2 << 16) |(b3 << 24)
  if v >= 0x80000000 then v = v - 0x100000000 end if
  return v
end function

/*
* Function: _PSV_CheckTag
* Purpose: Evaluates conditions and returns a decision for the internal module support.
*/
function _PSV_CheckTag(tag)
  b = bytes(tag)
  i = 0
  ok = true
  while i < 4
    expect = 0
    if i < len(b) then expect = b[i] end if
    got = _PSV_ReadU8()
    if got != expect then ok = false end if
    i = i + 1
  end while
  return ok
end function

/*
* Function: _PSV_ReadFixedString
* Purpose: Implements the _PSV_ReadFixedString routine for the internal module support.
*/
function _PSV_ReadFixedString(width)
  b = bytes(width, 0)
  i = 0
  while i < width
    b[i] = _PSV_ReadU8()
    i = i + 1
  end while
  return decodeZ(b)
end function

/*
* Function: _PSV_ObjIndex
* Purpose: Implements the _PSV_ObjIndex routine for the internal module support.
*/
function _PSV_ObjIndex(arr, obj)
  if obj is void then return -1 end if
  if typeof(arr) != "array" then return -1 end if
  i = 0
  while i < len(arr)
    if arr[i] == obj then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _PSV_PlayerIndex
* Purpose: Implements the _PSV_PlayerIndex routine for the internal module support.
*/
function _PSV_PlayerIndex(p)
  if typeof(players) != "array" then return -1 end if
  return _PSV_ObjIndex(players, p)
end function

/*
* Function: _PSV_SectorIndex
* Purpose: Implements the _PSV_SectorIndex routine for the internal module support.
*/
function _PSV_SectorIndex(sec)
  if typeof(sectors) != "array" then return -1 end if
  return _PSV_ObjIndex(sectors, sec)
end function

/*
* Function: _PSV_StateToIndex
* Purpose: Implements the _PSV_StateToIndex routine for the internal module support.
*/
function _PSV_StateToIndex(st)
  if st is void then return -1 end if
  if typeof(st) == "int" then return st end if
  if typeof(states) == "array" then
    i = 0
    while i < len(states)
      if states[i] == st then return i end if
      i = i + 1
    end while
  end if
  return Info_StateIndex(st)
end function

/*
* Function: _PSV_StateFromIndex
* Purpose: Implements the _PSV_StateFromIndex routine for the internal module support.
*/
function _PSV_StateFromIndex(idx)
  if typeof(idx) != "int" or idx < 0 then return void end if
  if typeof(states) == "array" and idx < len(states) then
    return states[idx]
  end if
  return idx
end function

/*
* Function: _PSV_WriteMapthing
* Purpose: Implements the _PSV_WriteMapthing routine for the internal module support.
*/
function _PSV_WriteMapthing(mt)
  if mt is void then
    _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
    return
  end if
  _PSV_WriteS32(mt.x)
  _PSV_WriteS32(mt.y)
  _PSV_WriteS32(mt.angle)
  _PSV_WriteS32(mt.type)
  _PSV_WriteS32(mt.options)
end function

/*
* Function: _PSV_ReadMapthing
* Purpose: Implements the _PSV_ReadMapthing routine for the internal module support.
*/
function _PSV_ReadMapthing()
  return mapthing_t(_PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
end function

/*
* Function: _PSV_WriteTiccmd
* Purpose: Implements the _PSV_WriteTiccmd routine for the internal module support.
*/
function _PSV_WriteTiccmd(cmd)
  if cmd is void then
    _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
    return
  end if
  _PSV_WriteS32(cmd.forwardmove)
  _PSV_WriteS32(cmd.sidemove)
  _PSV_WriteS32(cmd.angleturn)
  _PSV_WriteS32(cmd.consistancy)
  _PSV_WriteS32(cmd.chatchar)
  _PSV_WriteS32(cmd.buttons)
end function

/*
* Function: _PSV_ReadTiccmd
* Purpose: Implements the _PSV_ReadTiccmd routine for the internal module support.
*/
function _PSV_ReadTiccmd()
  return ticcmd_t(_PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
end function

/*
* Function: _PSV_WritePsprite
* Purpose: Implements the _PSV_WritePsprite routine for the internal module support.
*/
function _PSV_WritePsprite(psp)
  if psp is void then
    _PSV_WriteS32(-1); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
    return
  end if
  _PSV_WriteS32(_PSV_StateToIndex(psp.state))
  _PSV_WriteS32(psp.tics)
  _PSV_WriteS32(psp.sx)
  _PSV_WriteS32(psp.sy)
end function

/*
* Function: _PSV_ReadPsprite
* Purpose: Implements the _PSV_ReadPsprite routine for the internal module support.
*/
function _PSV_ReadPsprite()
  stidx = _PSV_ReadS32()
  tics = _PSV_ReadS32()
  sx = _PSV_ReadS32()
  sy = _PSV_ReadS32()
  return pspdef_t(_PSV_StateFromIndex(stidx), tics, sx, sy)
end function

/*
* Function: _PSV_ClearThingLists
* Purpose: Implements the _PSV_ClearThingLists routine for the internal module support.
*/
function _PSV_ClearThingLists()
  if typeof(sectors) != "array" then return end if
  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void then
      sec.thinglist = void
      sec.specialdata = void
      sec.soundtarget = void
    end if
    i = i + 1
  end while
end function

/*
* Function: _PSV_ClearBlockLinks
* Purpose: Implements the _PSV_ClearBlockLinks routine for the internal module support.
*/
function _PSV_ClearBlockLinks()
  if typeof(blocklinks) != "array" then return end if
  i = 0
  while i < len(blocklinks)
    blocklinks[i] = 0
    i = i + 1
  end while
end function

/*
* Function: _PSV_ArchivePlayerV2
* Purpose: Implements the _PSV_ArchivePlayerV2 routine for the internal module support.
*/
function _PSV_ArchivePlayerV2(p)
  _PSV_WriteS32(p.playerstate)
  _PSV_WriteTiccmd(p.cmd)
  _PSV_WriteS32(p.viewz)
  _PSV_WriteS32(p.viewheight)
  _PSV_WriteS32(p.deltaviewheight)
  _PSV_WriteS32(p.bob)
  _PSV_WriteS32(p.health)
  _PSV_WriteS32(p.armorpoints)
  _PSV_WriteS32(p.armortype)

  for j = 0 to NUMPOWERS - 1
    v = 0
    if typeof(p.powers) == "array" and j < len(p.powers) then v = p.powers[j] end if
    _PSV_WriteS32(v)
  end for
  for j = 0 to NUMCARDS - 1
    v = false
    if typeof(p.cards) == "array" and j < len(p.cards) then v = p.cards[j] end if
    _PSV_WriteBool(v)
  end for
  _PSV_WriteBool(p.backpack)

  for j = 0 to MAXPLAYERS - 1
    v = 0
    if typeof(p.frags) == "array" and j < len(p.frags) then v = p.frags[j] end if
    _PSV_WriteS32(v)
  end for

  _PSV_WriteS32(p.readyweapon)
  _PSV_WriteS32(p.pendingweapon)

  for j = 0 to NUMWEAPONS - 1
    v = false
    if typeof(p.weaponowned) == "array" and j < len(p.weaponowned) then v = p.weaponowned[j] end if
    _PSV_WriteBool(v)
  end for
  for j = 0 to NUMAMMO - 1
    v = 0
    if typeof(p.ammo) == "array" and j < len(p.ammo) then v = p.ammo[j] end if
    _PSV_WriteS32(v)
  end for
  for j = 0 to NUMAMMO - 1
    v = 0
    if typeof(p.maxammo) == "array" and j < len(p.maxammo) then v = p.maxammo[j] end if
    _PSV_WriteS32(v)
  end for

  _PSV_WriteBool(p.attackdown)
  _PSV_WriteBool(p.usedown)
  _PSV_WriteS32(p.cheats)
  _PSV_WriteS32(p.refire)
  _PSV_WriteS32(p.killcount)
  _PSV_WriteS32(p.itemcount)
  _PSV_WriteS32(p.secretcount)
  _PSV_WriteS32(p.damagecount)
  _PSV_WriteS32(p.bonuscount)
  _PSV_WriteS32(p.extralight)
  _PSV_WriteS32(p.fixedcolormap)
  _PSV_WriteS32(p.colormap)

  pscount = 0
  if typeof(NUMPSPRITES) == "int" then
    pscount = NUMPSPRITES
  else if typeof(p.psprites) == "array" then
    pscount = len(p.psprites)
  end if
  _PSV_WriteS32(pscount)
  for j = 0 to pscount - 1
    sp = void
    if typeof(p.psprites) == "array" and j < len(p.psprites) then sp = p.psprites[j] end if
    _PSV_WritePsprite(sp)
  end for
  _PSV_WriteBool(p.didsecret)
end function

/*
* Function: _PSV_UnArchivePlayerV1
* Purpose: Implements the _PSV_UnArchivePlayerV1 routine for the internal module support.
*/
function _PSV_UnArchivePlayerV1(p)
  p.playerstate = _PSV_ReadS32()
  p.health = _PSV_ReadS32()
  p.armorpoints = _PSV_ReadS32()
  p.armortype = _PSV_ReadS32()
  p.readyweapon = _PSV_ReadS32()
  p.pendingweapon = _PSV_ReadS32()
  p.cheats = _PSV_ReadS32()
  p.refire = _PSV_ReadS32()
  p.killcount = _PSV_ReadS32()
  p.itemcount = _PSV_ReadS32()
  p.secretcount = _PSV_ReadS32()
  p.damagecount = _PSV_ReadS32()
  p.bonuscount = _PSV_ReadS32()
  p.viewz = _PSV_ReadS32()
  p.viewheight = _PSV_ReadS32()
  p.deltaviewheight = _PSV_ReadS32()
  p.bob = _PSV_ReadS32()

  fr =[]
  for j = 0 to MAXPLAYERS - 1
    fr = fr +[_PSV_ReadS32()]
  end for
  p.frags = fr

  pw =[]
  for j = 0 to NUMPOWERS - 1
    pw = pw +[_PSV_ReadS32()]
  end for
  p.powers = pw

  cd =[]
  for j = 0 to NUMCARDS - 1
    cd = cd +[_PSV_ReadBool()]
  end for
  p.cards = cd

  am =[]
  for j = 0 to NUMAMMO - 1
    am = am +[_PSV_ReadS32()]
  end for
  p.ammo = am

  ma =[]
  for j = 0 to NUMAMMO - 1
    ma = ma +[_PSV_ReadS32()]
  end for
  p.maxammo = ma

  wo =[]
  for j = 0 to NUMWEAPONS - 1
    wo = wo +[_PSV_ReadBool()]
  end for
  p.weaponowned = wo

  p.cmd = ticcmd_t(0, 0, 0, 0, 0, 0)
  p.backpack = false
  p.attackdown = false
  p.usedown = false
  p.extralight = 0
  p.fixedcolormap = 0
  p.colormap = 0
  p.didsecret = false
  p.psprites =[]
  if typeof(NUMPSPRITES) == "int" then
    for j = 0 to NUMPSPRITES - 1
      p.psprites = p.psprites +[pspdef_t(void, 0, 0, 0)]
    end for
  end if
end function

/*
* Function: _PSV_UnArchivePlayerV2
* Purpose: Implements the _PSV_UnArchivePlayerV2 routine for the internal module support.
*/
function _PSV_UnArchivePlayerV2(p)
  p.playerstate = _PSV_ReadS32()
  p.cmd = _PSV_ReadTiccmd()
  p.viewz = _PSV_ReadS32()
  p.viewheight = _PSV_ReadS32()
  p.deltaviewheight = _PSV_ReadS32()
  p.bob = _PSV_ReadS32()
  p.health = _PSV_ReadS32()
  p.armorpoints = _PSV_ReadS32()
  p.armortype = _PSV_ReadS32()

  pw =[]
  for j = 0 to NUMPOWERS - 1
    pw = pw +[_PSV_ReadS32()]
  end for
  p.powers = pw

  cd =[]
  for j = 0 to NUMCARDS - 1
    cd = cd +[_PSV_ReadBool()]
  end for
  p.cards = cd
  p.backpack = _PSV_ReadBool()

  fr =[]
  for j = 0 to MAXPLAYERS - 1
    fr = fr +[_PSV_ReadS32()]
  end for
  p.frags = fr

  p.readyweapon = _PSV_ReadS32()
  p.pendingweapon = _PSV_ReadS32()

  wo =[]
  for j = 0 to NUMWEAPONS - 1
    wo = wo +[_PSV_ReadBool()]
  end for
  p.weaponowned = wo

  am =[]
  for j = 0 to NUMAMMO - 1
    am = am +[_PSV_ReadS32()]
  end for
  p.ammo = am

  ma =[]
  for j = 0 to NUMAMMO - 1
    ma = ma +[_PSV_ReadS32()]
  end for
  p.maxammo = ma

  p.attackdown = _PSV_ReadBool()
  p.usedown = _PSV_ReadBool()
  p.cheats = _PSV_ReadS32()
  p.refire = _PSV_ReadS32()
  p.killcount = _PSV_ReadS32()
  p.itemcount = _PSV_ReadS32()
  p.secretcount = _PSV_ReadS32()
  p.damagecount = _PSV_ReadS32()
  p.bonuscount = _PSV_ReadS32()
  p.extralight = _PSV_ReadS32()
  p.fixedcolormap = _PSV_ReadS32()
  p.colormap = _PSV_ReadS32()

  pscount = _PSV_ReadS32()
  if pscount < 0 then pscount = 0 end if
  p.psprites =[]
  for j = 0 to pscount - 1
    p.psprites = p.psprites +[_PSV_ReadPsprite()]
  end for
  if typeof(NUMPSPRITES) == "int" and pscount < NUMPSPRITES then
    for j = pscount to NUMPSPRITES - 1
      p.psprites = p.psprites +[pspdef_t(void, 0, 0, 0)]
    end for
  end if
  p.didsecret = _PSV_ReadBool()
end function

/*
* Function: P_ArchivePlayers
* Purpose: Implements the P_ArchivePlayers routine for the gameplay and world simulation.
*/
function P_ArchivePlayers()
  _PSV_WriteTag("PLYR")
  _PSV_WriteU8(2)
  _PSV_WriteU8(MAXPLAYERS)

  for i = 0 to MAXPLAYERS - 1
    ingame = false
    if typeof(playeringame) == "array" and i < len(playeringame) then ingame = playeringame[i] end if
    _PSV_WriteBool(ingame)
    if not ingame then continue end if

    p = void
    if typeof(players) == "array" and i < len(players) then p = players[i] end if
    if typeof(p) != "struct" then p = Player_MakeDefault() end if
    _PSV_ArchivePlayerV2(p)
  end for
end function

/*
* Function: P_UnArchivePlayers
* Purpose: Implements the P_UnArchivePlayers routine for the gameplay and world simulation.
*/
function P_UnArchivePlayers()
  ok = _PSV_CheckTag("PLYR")
  if not ok then return end if
  ver = _PSV_ReadU8()
  count = _PSV_ReadU8()

  for i = 0 to MAXPLAYERS - 1
    ingame = false
    if i < count then ingame = _PSV_ReadBool() end if

    if typeof(playeringame) == "array" and i < len(playeringame) then
      playeringame[i] = ingame
    end if

    if not ingame then
      if typeof(players) == "array" and i < len(players) and typeof(players[i]) != "struct" then
        players[i] = Player_MakeDefault()
      end if
      continue
    end if

    p = void
    if typeof(players) == "array" and i < len(players) then p = players[i] end if
    if typeof(p) != "struct" then p = Player_MakeDefault() end if

    if ver >= 2 then
      _PSV_UnArchivePlayerV2(p)
    else
      _PSV_UnArchivePlayerV1(p)
    end if

    p.mo = void
    p.message = void
    p.attacker = void
    if typeof(players) == "array" and i < len(players) then players[i] = p end if
  end for
end function

/*
* Function: P_ArchiveWorld
* Purpose: Implements the P_ArchiveWorld routine for the gameplay and world simulation.
*/
function P_ArchiveWorld()
  _PSV_WriteTag("WRLD")
  _PSV_WriteU8(1)

  secCount = 0
  if typeof(sectors) == "array" then secCount = len(sectors) end if
  lineCount = 0
  if typeof(lines) == "array" then lineCount = len(lines) end if

  _PSV_WriteS32(secCount)
  _PSV_WriteS32(lineCount)

  i = 0
  while i < secCount
    sec = sectors[i]
    if sec is void then
      _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
    else
      _PSV_WriteS32(sec.floorheight)
      _PSV_WriteS32(sec.ceilingheight)
      _PSV_WriteS32(sec.floorpic)
      _PSV_WriteS32(sec.ceilingpic)
      _PSV_WriteS32(sec.lightlevel)
      _PSV_WriteS32(sec.special)
      _PSV_WriteS32(sec.tag)
    end if
    i = i + 1
  end while

  i = 0
  while i < lineCount
    li = lines[i]
    if li is void then
      _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
      _PSV_WriteS32(-1); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
      _PSV_WriteS32(-1); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
    else
      _PSV_WriteS32(li.flags)
      _PSV_WriteS32(li.special)
      _PSV_WriteS32(li.tag)

      for j = 0 to 1
        sid = -1
        if typeof(li.sidenum) == "array" and j < len(li.sidenum) then sid = li.sidenum[j] end if
        _PSV_WriteS32(sid)
        if sid >= 0 and typeof(sides) == "array" and sid < len(sides) and sides[sid] is not void then
          si = sides[sid]
          _PSV_WriteS32(si.textureoffset)
          _PSV_WriteS32(si.rowoffset)
          _PSV_WriteS32(si.toptexture)
          _PSV_WriteS32(si.bottomtexture)
          _PSV_WriteS32(si.midtexture)
        else
          _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0); _PSV_WriteS32(0)
        end if
      end for
    end if
    i = i + 1
  end while
end function

/*
* Function: P_UnArchiveWorld
* Purpose: Implements the P_UnArchiveWorld routine for the gameplay and world simulation.
*/
function P_UnArchiveWorld()
  ok = _PSV_CheckTag("WRLD")
  if not ok then return end if
  _ = _PSV_ReadU8()
  secCount = _PSV_ReadS32()
  lineCount = _PSV_ReadS32()

  i = 0
  while i < secCount
    fh = _PSV_ReadS32()
    ch = _PSV_ReadS32()
    fp = _PSV_ReadS32()
    cp = _PSV_ReadS32()
    ll = _PSV_ReadS32()
    sp = _PSV_ReadS32()
    tg = _PSV_ReadS32()

    if typeof(sectors) == "array" and i < len(sectors) and sectors[i] is not void then
      sec = sectors[i]
      sec.floorheight = fh
      sec.ceilingheight = ch
      sec.floorpic = fp
      sec.ceilingpic = cp
      sec.lightlevel = ll
      sec.special = sp
      sec.tag = tg
      sec.specialdata = void
      sec.soundtarget = void
    end if
    i = i + 1
  end while

  i = 0
  while i < lineCount
    flags = _PSV_ReadS32()
    sp = _PSV_ReadS32()
    tg = _PSV_ReadS32()

    if typeof(lines) == "array" and i < len(lines) and lines[i] is not void then
      li = lines[i]
      li.flags = flags
      li.special = sp
      li.tag = tg
      li.specialdata = void
    end if

    for j = 0 to 1
      sid = _PSV_ReadS32()
      toff = _PSV_ReadS32()
      roff = _PSV_ReadS32()
      tt = _PSV_ReadS32()
      bt = _PSV_ReadS32()
      mt = _PSV_ReadS32()

      if sid >= 0 and typeof(sides) == "array" and sid < len(sides) and sides[sid] is not void then
        si = sides[sid]
        si.textureoffset = toff
        si.rowoffset = roff
        si.toptexture = tt
        si.bottomtexture = bt
        si.midtexture = mt
      end if
    end for
    i = i + 1
  end while
end function

const _PSV_TC_MOBJ = 1

const _PSV_SC_CEILING = 1
const _PSV_SC_DOOR = 2
const _PSV_SC_FLOOR = 3
const _PSV_SC_PLAT = 4
const _PSV_SC_FLASH = 5
const _PSV_SC_STROBE = 6
const _PSV_SC_GLOW = 7

/*
* Function: _PSV_ResolveThinkerMobj
* Purpose: Advances per-tick logic for the internal module support.
*/
function _PSV_ResolveThinkerMobj(node)
  if node is void then return void end if
  mo = void
  if typeof(P_ResolveThinkerOwner) == "function" then
    mo = P_ResolveThinkerOwner(node)
  end if
  if mo is void and typeof(_PM_ResolveThinkerOwner) == "function" then
    mo = _PM_ResolveThinkerOwner(node)
  end if
  if mo is void then return void end if
  if typeof(mo.x) == "void" or typeof(mo.y) == "void" or typeof(mo.type) == "void" then
    return void
  end if
  return mo
end function

/*
* Function: _PSV_WriteMobj
* Purpose: Implements the _PSV_WriteMobj routine for the internal module support.
*/
function _PSV_WriteMobj(mo)
  _PSV_WriteS32(mo.x)
  _PSV_WriteS32(mo.y)
  _PSV_WriteS32(mo.z)
  _PSV_WriteS32(mo.angle)
  _PSV_WriteS32(mo.sprite)
  _PSV_WriteS32(mo.frame)

  _PSV_WriteS32(mo.floorz)
  _PSV_WriteS32(mo.ceilingz)
  _PSV_WriteS32(mo.radius)
  _PSV_WriteS32(mo.height)

  _PSV_WriteS32(mo.momx)
  _PSV_WriteS32(mo.momy)
  _PSV_WriteS32(mo.momz)

  _PSV_WriteS32(mo.validcount)
  _PSV_WriteS32(mo.type)
  _PSV_WriteS32(_PSV_StateToIndex(mo.state))
  _PSV_WriteS32(mo.tics)
  _PSV_WriteS32(mo.flags)
  _PSV_WriteS32(mo.health)

  _PSV_WriteS32(mo.movedir)
  _PSV_WriteS32(mo.movecount)
  _PSV_WriteS32(mo.reactiontime)
  _PSV_WriteS32(mo.threshold)
  _PSV_WriteS32(mo.lastlook)

  pidx = _PSV_PlayerIndex(mo.player)
  _PSV_WriteS32(pidx + 1)
  _PSV_WriteMapthing(mo.spawnpoint)
end function

/*
* Function: _PSV_ReadMobj
* Purpose: Implements the _PSV_ReadMobj routine for the internal module support.
*/
function _PSV_ReadMobj()
  mo = _Mobj_Default()

  mo.x = _PSV_ReadS32()
  mo.y = _PSV_ReadS32()
  mo.z = _PSV_ReadS32()
  mo.angle = _PSV_ReadS32()
  mo.sprite = _PSV_ReadS32()
  mo.frame = _PSV_ReadS32()

  mo.floorz = _PSV_ReadS32()
  mo.ceilingz = _PSV_ReadS32()
  mo.radius = _PSV_ReadS32()
  mo.height = _PSV_ReadS32()

  mo.momx = _PSV_ReadS32()
  mo.momy = _PSV_ReadS32()
  mo.momz = _PSV_ReadS32()

  mo.validcount = _PSV_ReadS32()
  mo.type = _PSV_ReadS32()
  stidx = _PSV_ReadS32()
  mo.tics = _PSV_ReadS32()
  mo.flags = _PSV_ReadS32()
  mo.health = _PSV_ReadS32()

  mo.movedir = _PSV_ReadS32()
  mo.movecount = _PSV_ReadS32()
  mo.reactiontime = _PSV_ReadS32()
  mo.threshold = _PSV_ReadS32()
  mo.lastlook = _PSV_ReadS32()

  pidx = _PSV_ReadS32() - 1
  mo.spawnpoint = _PSV_ReadMapthing()

  mo.state = _PSV_StateFromIndex(stidx)
  mo.target = void
  mo.tracer = void
  mo.snext = void
  mo.sprev = void
  mo.bnext = void
  mo.bprev = void

  if typeof(mobjinfo) == "array" and mo.type >= 0 and mo.type < len(mobjinfo) then
    mo.info = mobjinfo[mo.type]
  else
    mo.info = void
  end if

  if mo.thinker is void then
    mo.thinker = thinker_t(void, void, actionf_t(void, void, void), void)
  end if
  mo.thinker.func = actionf_t(P_MobjThinker, void, void)
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(mo.thinker, mo) end if
  if typeof(_PM_RegisterThinker) == "function" then _PM_RegisterThinker(mo.thinker, mo) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(mo.thinker) end if
  if typeof(P_SetThingPosition) == "function" then P_SetThingPosition(mo) end if

  if mo.subsector is not void and mo.subsector.sector is not void then
    mo.floorz = mo.subsector.sector.floorheight
    mo.ceilingz = mo.subsector.sector.ceilingheight
  end if

  mo.player = void
  if pidx >= 0 and typeof(players) == "array" and pidx < len(players) and typeof(players[pidx]) == "struct" then
    pp = players[pidx]
    mo.player = pp
    pp.mo = mo
    players[pidx] = pp
  end if
  return mo
end function

/*
* Function: P_ArchiveThinkers
* Purpose: Advances per-tick logic for the gameplay and world simulation.
*/
function P_ArchiveThinkers()
  _PSV_WriteTag("THKR")
  _PSV_WriteU8(1)

  count = 0
  cur = thinkercap.next
  while cur != thinkercap
    if cur.func is not void and cur.func.acp1 == P_MobjThinker then
      mo = _PSV_ResolveThinkerMobj(cur)
      if mo is not void then count = count + 1 end if
    end if
    cur = cur.next
  end while

  _PSV_WriteS32(count)
  cur = thinkercap.next
  while cur != thinkercap
    if cur.func is not void and cur.func.acp1 == P_MobjThinker then
      mo = _PSV_ResolveThinkerMobj(cur)
      if mo is not void then
        _PSV_WriteS32(_PSV_TC_MOBJ)
        _PSV_WriteMobj(mo)
      end if
    end if
    cur = cur.next
  end while
end function

/*
* Function: P_UnArchiveThinkers
* Purpose: Advances per-tick logic for the gameplay and world simulation.
*/
function P_UnArchiveThinkers()
  ok = _PSV_CheckTag("THKR")
  if not ok then return end if
  _ = _PSV_ReadU8()
  count = _PSV_ReadS32()

  _PSV_ClearThingLists()
  _PSV_ClearBlockLinks()

  if typeof(players) == "array" then
    i = 0
    while i < len(players)
      if typeof(players[i]) == "struct" then
        p = players[i]
        p.mo = void
        players[i] = p
      end if
      i = i + 1
    end while
  end if
  if typeof(P_InitThinkers) == "function" then P_InitThinkers() end if
  if typeof(_pm_thinker_nodes) == "array" then _pm_thinker_nodes =[] end if
  if typeof(_pm_thinker_owners) == "array" then _pm_thinker_owners =[] end if

  i = 0
  while i < count
    tclass = _PSV_ReadS32()
    if tclass == _PSV_TC_MOBJ then
      _PSV_ReadMobj()
    end if
    i = i + 1
  end while
end function

/*
* Function: _PSV_WriteCeiling
* Purpose: Implements the _PSV_WriteCeiling routine for the internal module support.
*/
function _PSV_WriteCeiling(c)
  _PSV_WriteS32(_PSV_SectorIndex(c.sector))
  _PSV_WriteS32(c.type)
  _PSV_WriteS32(c.bottomheight)
  _PSV_WriteS32(c.topheight)
  _PSV_WriteS32(c.speed)
  _PSV_WriteBool(c.crush)
  _PSV_WriteS32(c.direction)
  _PSV_WriteS32(c.tag)
  _PSV_WriteS32(c.olddirection)
end function

/*
* Function: _PSV_WriteDoor
* Purpose: Implements the _PSV_WriteDoor routine for the internal module support.
*/
function _PSV_WriteDoor(d)
  _PSV_WriteS32(_PSV_SectorIndex(d.sector))
  _PSV_WriteS32(d.type)
  _PSV_WriteS32(d.topheight)
  _PSV_WriteS32(d.speed)
  _PSV_WriteS32(d.direction)
  _PSV_WriteS32(d.topwait)
  _PSV_WriteS32(d.topcountdown)
end function

/*
* Function: _PSV_WriteFloor
* Purpose: Implements the _PSV_WriteFloor routine for the internal module support.
*/
function _PSV_WriteFloor(f)
  _PSV_WriteS32(_PSV_SectorIndex(f.sector))
  _PSV_WriteS32(f.type)
  _PSV_WriteBool(f.crush)
  _PSV_WriteS32(f.direction)
  _PSV_WriteS32(f.newspecial)
  _PSV_WriteS32(f.texture)
  _PSV_WriteS32(f.floordestheight)
  _PSV_WriteS32(f.speed)
end function

/*
* Function: _PSV_WritePlat
* Purpose: Implements the _PSV_WritePlat routine for the internal module support.
*/
function _PSV_WritePlat(p)
  _PSV_WriteS32(_PSV_SectorIndex(p.sector))
  _PSV_WriteS32(p.speed)
  _PSV_WriteS32(p.low)
  _PSV_WriteS32(p.high)
  _PSV_WriteS32(p.wait)
  _PSV_WriteS32(p.count)
  _PSV_WriteS32(p.status)
  _PSV_WriteS32(p.oldstatus)
  _PSV_WriteBool(p.crush)
  _PSV_WriteS32(p.tag)
  _PSV_WriteS32(p.type)
end function

/*
* Function: _PSV_WriteFlash
* Purpose: Implements the _PSV_WriteFlash routine for the internal module support.
*/
function _PSV_WriteFlash(f)
  _PSV_WriteS32(_PSV_SectorIndex(f.sector))
  _PSV_WriteS32(f.count)
  _PSV_WriteS32(f.maxlight)
  _PSV_WriteS32(f.minlight)
  _PSV_WriteS32(f.maxtime)
  _PSV_WriteS32(f.mintime)
end function

/*
* Function: _PSV_WriteStrobe
* Purpose: Evaluates conditions and returns a decision for the internal module support.
*/
function _PSV_WriteStrobe(s)
  _PSV_WriteS32(_PSV_SectorIndex(s.sector))
  _PSV_WriteS32(s.count)
  _PSV_WriteS32(s.minlight)
  _PSV_WriteS32(s.maxlight)
  _PSV_WriteS32(s.darktime)
  _PSV_WriteS32(s.brighttime)
end function

/*
* Function: _PSV_WriteGlow
* Purpose: Implements the _PSV_WriteGlow routine for the internal module support.
*/
function _PSV_WriteGlow(g)
  _PSV_WriteS32(_PSV_SectorIndex(g.sector))
  _PSV_WriteS32(g.minlight)
  _PSV_WriteS32(g.maxlight)
  _PSV_WriteS32(g.direction)
end function

/*
* Function: P_ArchiveSpecials
* Purpose: Implements the P_ArchiveSpecials routine for the gameplay and world simulation.
*/
function P_ArchiveSpecials()
  _PSV_WriteTag("SPCL")
  _PSV_WriteU8(1)

  count = 0
  cur = thinkercap.next
  while cur != thinkercap
    fn = void
    if cur.func is not void then fn = cur.func.acp1 end if
    if fn == T_MoveCeiling or fn == T_VerticalDoor or fn == T_MoveFloor or fn == T_PlatRaise or fn == T_LightFlash or fn == T_StrobeFlash or fn == T_Glow then
      count = count + 1
    end if
    cur = cur.next
  end while

  _PSV_WriteS32(count)
  cur = thinkercap.next
  while cur != thinkercap
    fn = void
    if cur.func is not void then fn = cur.func.acp1 end if
    o = void
    if typeof(P_ResolveThinkerOwner) == "function" then o = P_ResolveThinkerOwner(cur) end if
    if o is void then
      cur = cur.next
      continue
    end if

    if fn == T_MoveCeiling then
      _PSV_WriteS32(_PSV_SC_CEILING)
      _PSV_WriteCeiling(o)
    else if fn == T_VerticalDoor then
      _PSV_WriteS32(_PSV_SC_DOOR)
      _PSV_WriteDoor(o)
    else if fn == T_MoveFloor then
      _PSV_WriteS32(_PSV_SC_FLOOR)
      _PSV_WriteFloor(o)
    else if fn == T_PlatRaise then
      _PSV_WriteS32(_PSV_SC_PLAT)
      _PSV_WritePlat(o)
    else if fn == T_LightFlash then
      _PSV_WriteS32(_PSV_SC_FLASH)
      _PSV_WriteFlash(o)
    else if fn == T_StrobeFlash then
      _PSV_WriteS32(_PSV_SC_STROBE)
      _PSV_WriteStrobe(o)
    else if fn == T_Glow then
      _PSV_WriteS32(_PSV_SC_GLOW)
      _PSV_WriteGlow(o)
    end if
    cur = cur.next
  end while
end function

/*
* Function: _PSV_ReadSectorRef
* Purpose: Implements the _PSV_ReadSectorRef routine for the internal module support.
*/
function _PSV_ReadSectorRef()
  idx = _PSV_ReadS32()
  if typeof(sectors) != "array" then return void end if
  if idx < 0 or idx >= len(sectors) then return void end if
  return sectors[idx]
end function

/*
* Function: _PSV_ReadCeiling
* Purpose: Implements the _PSV_ReadCeiling routine for the internal module support.
*/
function _PSV_ReadCeiling()
  sec = _PSV_ReadSectorRef()
  c = ceiling_t(thinker_t(void, void, actionf_t(T_MoveCeiling, void, void), void),
  _PSV_ReadS32(), sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadBool(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if sec is not void then sec.specialdata = c end if
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(c.thinker, c) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(c.thinker) end if
  if typeof(P_AddActiveCeiling) == "function" then P_AddActiveCeiling(c) end if
end function

/*
* Function: _PSV_ReadDoor
* Purpose: Implements the _PSV_ReadDoor routine for the internal module support.
*/
function _PSV_ReadDoor()
  sec = _PSV_ReadSectorRef()
  d = vldoor_t(thinker_t(void, void, actionf_t(T_VerticalDoor, void, void), void),
  _PSV_ReadS32(), sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if sec is not void then sec.specialdata = d end if
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(d.thinker, d) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(d.thinker) end if
end function

/*
* Function: _PSV_ReadFloor
* Purpose: Implements the _PSV_ReadFloor routine for the internal module support.
*/
function _PSV_ReadFloor()
  sec = _PSV_ReadSectorRef()
  f = floormove_t(thinker_t(void, void, actionf_t(T_MoveFloor, void, void), void),
  _PSV_ReadS32(), _PSV_ReadBool(), sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if sec is not void then sec.specialdata = f end if
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(f.thinker, f) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(f.thinker) end if
end function

/*
* Function: _PSV_ReadPlat
* Purpose: Implements the _PSV_ReadPlat routine for the internal module support.
*/
function _PSV_ReadPlat()
  sec = _PSV_ReadSectorRef()
  p = plat_t(thinker_t(void, void, actionf_t(T_PlatRaise, void, void), void),
  sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(),
  _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadBool(), _PSV_ReadS32(), _PSV_ReadS32())
  if sec is not void then sec.specialdata = p end if
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(p.thinker, p) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(p.thinker) end if
  if typeof(P_AddActivePlat) == "function" then P_AddActivePlat(p) end if
end function

/*
* Function: _PSV_ReadFlash
* Purpose: Implements the _PSV_ReadFlash routine for the internal module support.
*/
function _PSV_ReadFlash()
  sec = _PSV_ReadSectorRef()
  f = lightflash_t(thinker_t(void, void, actionf_t(T_LightFlash, void, void), void),
  sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(f.thinker, f) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(f.thinker) end if
end function

/*
* Function: _PSV_ReadStrobe
* Purpose: Implements the _PSV_ReadStrobe routine for the internal module support.
*/
function _PSV_ReadStrobe()
  sec = _PSV_ReadSectorRef()
  s = strobe_t(thinker_t(void, void, actionf_t(T_StrobeFlash, void, void), void),
  sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(s.thinker, s) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(s.thinker) end if
end function

/*
* Function: _PSV_ReadGlow
* Purpose: Implements the _PSV_ReadGlow routine for the internal module support.
*/
function _PSV_ReadGlow()
  sec = _PSV_ReadSectorRef()
  g = glow_t(thinker_t(void, void, actionf_t(T_Glow, void, void), void),
  sec, _PSV_ReadS32(), _PSV_ReadS32(), _PSV_ReadS32())
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(g.thinker, g) end if
  if typeof(P_AddThinker) == "function" then P_AddThinker(g.thinker) end if
end function

/*
* Function: P_UnArchiveSpecials
* Purpose: Implements the P_UnArchiveSpecials routine for the gameplay and world simulation.
*/
function P_UnArchiveSpecials()
  ok = _PSV_CheckTag("SPCL")
  if not ok then return end if
  _ = _PSV_ReadU8()
  count = _PSV_ReadS32()

  if typeof(activeceilings) == "array" then
    n = len(activeceilings)
    if n > MAXCEILINGS then n = MAXCEILINGS end if
    cleared =[]
    i = 0
    while i < n
      cleared = cleared +[void]
      i = i + 1
    end while
    activeceilings = cleared
  end if
  if typeof(activeplats) == "array" then
    n = len(activeplats)
    if n > MAXPLATS then n = MAXPLATS end if
    cleared =[]
    i = 0
    while i < n
      cleared = cleared +[void]
      i = i + 1
    end while
    activeplats = cleared
  end if

  i = 0
  while i < count
    tclass = _PSV_ReadS32()
    if tclass == _PSV_SC_CEILING then
      _PSV_ReadCeiling()
    else if tclass == _PSV_SC_DOOR then
      _PSV_ReadDoor()
    else if tclass == _PSV_SC_FLOOR then
      _PSV_ReadFloor()
    else if tclass == _PSV_SC_PLAT then
      _PSV_ReadPlat()
    else if tclass == _PSV_SC_FLASH then
      _PSV_ReadFlash()
    else if tclass == _PSV_SC_STROBE then
      _PSV_ReadStrobe()
    else if tclass == _PSV_SC_GLOW then
      _PSV_ReadGlow()
    else
      I_Error("P_UnArchiveSpecials: unknown class " + tclass)
    end if
    i = i + 1
  end while
end function



