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

  Script: p_setup.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import m_swap
import m_bbox
import m_fixed
import g_game
import i_system
import w_wad
import doomdata
import doomdef
import p_local
import p_mobj
import p_switch
import p_spec
import p_tick
import s_sound
import doomstat
import d_player
import info
import r_data
import r_defs
import r_state
import r_things

/*
* Function: _PS_U16LE
* Purpose: Implements the _PS_U16LE routine for the internal module support.
*/
function _PS_U16LE(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/*
* Function: _PS_I16LE
* Purpose: Implements the _PS_I16LE routine for the internal module support.
*/
function _PS_I16LE(b, off)
  x = _PS_U16LE(b, off)
  if x >= 32768 then x = x - 65536 end if
  return x
end function

/*
* Function: _PS_ReadLumpBytes
* Purpose: Implements the _PS_ReadLumpBytes routine for the internal module support.
*/
function _PS_ReadLumpBytes(lump)
  n = W_LumpLength(lump)
  if n <= 0 then
    return bytes(0)
  end if
  lumpBytes = bytes(n, 0)
  W_ReadLump(lump, lumpBytes)
  return lumpBytes
end function

/*
* Function: _PS_Name8
* Purpose: Implements the _PS_Name8 routine for the internal module support.
*/
function _PS_Name8(data, off)
  return slice(data, off, 8)
end function

/*
* Function: _PSET_IDiv
* Purpose: Reads or updates state used by the internal module support.
*/
function _PSET_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _PSET_IsSeq
* Purpose: Reads or updates state used by the internal module support.
*/
function _PSET_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _PS_VertexOrZero
* Purpose: Implements the _PS_VertexOrZero routine for the internal module support.
*/
function _PS_VertexOrZero(idx)
  if idx < 0 or not _PSET_IsSeq(vertexes) or idx >= len(vertexes) then
    return vertex_t(0, 0)
  end if
  return vertexes[idx]
end function

/*
* Function: _PS_MapName
* Purpose: Implements the _PS_MapName routine for the internal module support.
*/
function _PS_MapName(episode, map)
  if gamemode == GameMode_t.commercial then
    if map < 10 then
      return "map0" + map
    end if
    return "map" + map
  end if
  return "E" + episode + "M" + map
end function

/*
* Function: _PS_EnsureRuntimeArrays
* Purpose: Implements the _PS_EnsureRuntimeArrays routine for the internal module support.
*/
function _PS_EnsureRuntimeArrays()
  global players
  global deathmatchstarts
  global deathmatch_p
  global playerstarts

  if not _PSET_IsSeq(players) or len(players) < MAXPLAYERS then
    players =[void, void, void, void]
  end if

  if not _PSET_IsSeq(deathmatchstarts) or len(deathmatchstarts) < 10 then
    deathmatchstarts =[]
    i = 0
    while i < 10
      deathmatchstarts = deathmatchstarts +[mapthing_t(0, 0, 0, 0, 0)]
      i = i + 1
    end while
  end if
  deathmatch_p = 0

  if not _PSET_IsSeq(playerstarts) or len(playerstarts) < MAXPLAYERS then
    playerstarts =[]
    i = 0
    while i < MAXPLAYERS
      playerstarts = playerstarts +[mapthing_t(0, 0, 0, 0, 0)]
      i = i + 1
    end while
  end if
end function

/*
* Function: P_LoadVertexes
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadVertexes(lump)
  global numvertexes
  global vertexes

  data = _PS_ReadLumpBytes(lump)
  numvertexes = _PSET_IDiv(len(data), 4)
  vertexes =[]

  i = 0
  while i < numvertexes
    off = i * 4
    x = _PS_I16LE(data, off) << FRACBITS
    y = _PS_I16LE(data, off + 2) << FRACBITS
    vertexes = vertexes +[vertex_t(x, y)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadSectors
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadSectors(lump)
  global numsectors
  global sectors

  data = _PS_ReadLumpBytes(lump)
  numsectors = _PSET_IDiv(len(data), 26)
  sectors =[]

  i = 0
  while i < numsectors
    off = i * 26

    floorheight = _PS_I16LE(data, off + 0) << FRACBITS
    ceilingheight = _PS_I16LE(data, off + 2) << FRACBITS
    floorpic = R_FlatNumForName(_PS_Name8(data, off + 4))
    ceilingpic = R_FlatNumForName(_PS_Name8(data, off + 12))
    lightlevel = _PS_I16LE(data, off + 20)
    special = _PS_I16LE(data, off + 22)
    tag = _PS_I16LE(data, off + 24)

    sec = sector_t(
    floorheight,
    ceilingheight,
    floorpic,
    ceilingpic,
    lightlevel,
    special,
    tag,
    0,
    void,
    [0, 0, 0, 0],
    degenmobj_t(void, 0, 0, 0),
    0,
    void,
    void,
    0,
    []
)
    sectors = sectors +[sec]
    i = i + 1
  end while
end function

/*
* Function: P_LoadSideDefs
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadSideDefs(lump)
  global numsides
  global sides

  data = _PS_ReadLumpBytes(lump)
  numsides = _PSET_IDiv(len(data), 30)
  sides =[]

  i = 0
  while i < numsides
    off = i * 30

    textureoffset = _PS_I16LE(data, off + 0) << FRACBITS
    rowoffset = _PS_I16LE(data, off + 2) << FRACBITS
    toptexture = R_TextureNumForName(_PS_Name8(data, off + 4))
    bottomtexture = R_TextureNumForName(_PS_Name8(data, off + 12))
    midtexture = R_TextureNumForName(_PS_Name8(data, off + 20))

    secnum = _PS_I16LE(data, off + 28)
    sec = void
    if secnum >= 0 and _PSET_IsSeq(sectors) and secnum < len(sectors) then
      sec = sectors[secnum]
    end if

    sides = sides +[side_t(textureoffset, rowoffset, toptexture, bottomtexture, midtexture, sec)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadLineDefs
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadLineDefs(lump)
  global numlines
  global lines

  data = _PS_ReadLumpBytes(lump)
  numlines = _PSET_IDiv(len(data), 14)
  lines =[]

  i = 0
  while i < numlines
    off = i * 14

    v1 = _PS_VertexOrZero(_PS_I16LE(data, off + 0))
    v2 = _PS_VertexOrZero(_PS_I16LE(data, off + 2))
    flags = _PS_I16LE(data, off + 4)
    special = _PS_I16LE(data, off + 6)
    tag = _PS_I16LE(data, off + 8)
    s0 = _PS_I16LE(data, off + 10)
    s1 = _PS_I16LE(data, off + 12)

    dx = v2.x - v1.x
    dy = v2.y - v1.y

    slope = slopetype_t.ST_HORIZONTAL
    if dx == 0 then
      slope = slopetype_t.ST_VERTICAL
    else if dy == 0 then
      slope = slopetype_t.ST_HORIZONTAL
    else if (dy > 0 and dx > 0) or(dy < 0 and dx < 0) then
      slope = slopetype_t.ST_POSITIVE
    else
      slope = slopetype_t.ST_NEGATIVE
    end if

    bbox =[0, 0, 0, 0]
    if v1.x < v2.x then
      bbox[BOXLEFT] = v1.x
      bbox[BOXRIGHT] = v2.x
    else
      bbox[BOXLEFT] = v2.x
      bbox[BOXRIGHT] = v1.x
    end if
    if v1.y < v2.y then
      bbox[BOXBOTTOM] = v1.y
      bbox[BOXTOP] = v2.y
    else
      bbox[BOXBOTTOM] = v2.y
      bbox[BOXTOP] = v1.y
    end if

    front = void
    if s0 >= 0 and _PSET_IsSeq(sides) and s0 < len(sides) then
      front = sides[s0].sector
    end if
    back = void
    if s1 >= 0 and _PSET_IsSeq(sides) and s1 < len(sides) then
      back = sides[s1].sector
    end if

    lines = lines +[line_t(v1, v2, dx, dy, flags, special, tag,[s0, s1], bbox, slope, front, back, 0, void)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadSubsectors
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadSubsectors(lump)
  global numsubsectors
  global subsectors

  data = _PS_ReadLumpBytes(lump)
  numsubsectors = _PSET_IDiv(len(data), 4)
  subsectors =[]

  i = 0
  while i < numsubsectors
    off = i * 4
    numsegs = _PS_I16LE(data, off + 0)
    firstseg = _PS_I16LE(data, off + 2)
    subsectors = subsectors +[subsector_t(void, numsegs, firstseg)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadNodes
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadNodes(lump)
  global numnodes
  global nodes

  data = _PS_ReadLumpBytes(lump)
  numnodes = _PSET_IDiv(len(data), 28)
  nodes =[]

  i = 0
  while i < numnodes
    off = i * 28

    x = _PS_I16LE(data, off + 0) << FRACBITS
    y = _PS_I16LE(data, off + 2) << FRACBITS
    dx = _PS_I16LE(data, off + 4) << FRACBITS
    dy = _PS_I16LE(data, off + 6) << FRACBITS

    bb0 =[
    _PS_I16LE(data, off + 8) << FRACBITS,
    _PS_I16LE(data, off + 10) << FRACBITS,
    _PS_I16LE(data, off + 12) << FRACBITS,
    _PS_I16LE(data, off + 14) << FRACBITS
]
    bb1 =[
    _PS_I16LE(data, off + 16) << FRACBITS,
    _PS_I16LE(data, off + 18) << FRACBITS,
    _PS_I16LE(data, off + 20) << FRACBITS,
    _PS_I16LE(data, off + 22) << FRACBITS
]

    children =[
    _PS_U16LE(data, off + 24),
    _PS_U16LE(data, off + 26)
]

    nodes = nodes +[node_t(x, y, dx, dy,[bb0, bb1], children)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadSegs
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadSegs(lump)
  global numsegs
  global segs

  data = _PS_ReadLumpBytes(lump)
  numsegs = _PSET_IDiv(len(data), 12)
  segs =[]

  i = 0
  while i < numsegs
    off = i * 12

    v1 = _PS_VertexOrZero(_PS_I16LE(data, off + 0))
    v2 = _PS_VertexOrZero(_PS_I16LE(data, off + 2))
    angle = _PS_I16LE(data, off + 4) << 16
    linedefIdx = _PS_I16LE(data, off + 6)
    side = _PS_I16LE(data, off + 8)
    offset = _PS_I16LE(data, off + 10) << FRACBITS

    ldef = void
    sd = void
    front = void
    back = void

    if linedefIdx >= 0 and _PSET_IsSeq(lines) and linedefIdx < len(lines) then
      ldef = lines[linedefIdx]
      if side < 0 then side = 0 end if

      sidx = -1
      if _PSET_IsSeq(ldef.sidenum) and side < len(ldef.sidenum) then
        sidx = ldef.sidenum[side]
      end if
      if sidx >= 0 and _PSET_IsSeq(sides) and sidx < len(sides) then
        sd = sides[sidx]
        front = sd.sector
      end if

      if (ldef.flags & ML_TWOSIDED) != 0 then
        os = side ^ 1
        if _PSET_IsSeq(ldef.sidenum) and os < len(ldef.sidenum) then
          bsidx = ldef.sidenum[os]
          if bsidx >= 0 and _PSET_IsSeq(sides) and bsidx < len(sides) then
            back = sides[bsidx].sector
          end if
        end if
      end if
    end if

    segs = segs +[seg_t(v1, v2, offset, angle, sd, ldef, front, back)]
    i = i + 1
  end while
end function

/*
* Function: P_LoadBlockMap
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadBlockMap(lump)
  global blockmaplump
  global blockmap
  global bmapwidth
  global bmapheight
  global bmaporgx
  global bmaporgy
  global blocklinks

  data = _PS_ReadLumpBytes(lump)
  count = _PSET_IDiv(len(data), 2)

  blockmaplump =[]
  i = 0
  while i < count
    blockmaplump = blockmaplump +[_PS_I16LE(data, i * 2)]
    i = i + 1
  end while

  if count < 4 then
    blockmap =[]
    bmaporgx = 0
    bmaporgy = 0
    bmapwidth = 0
    bmapheight = 0
    blocklinks =[]
    return
  end if

  bmaporgx = blockmaplump[0] << FRACBITS
  bmaporgy = blockmaplump[1] << FRACBITS
  bmapwidth = blockmaplump[2]
  bmapheight = blockmaplump[3]

  if bmapwidth < 0 then bmapwidth = 0 end if
  if bmapheight < 0 then bmapheight = 0 end if

  blockmap =[]
  ncell = bmapwidth * bmapheight
  i = 0
  while i < ncell and(4 + i) < len(blockmaplump)
    blockmap = blockmap +[blockmaplump[4 + i]]
    i = i + 1
  end while
  while i < ncell
    blockmap = blockmap +[0]
    i = i + 1
  end while

  blocklinks =[]
  n = bmapwidth * bmapheight
  i = 0
  while i < n
    blocklinks = blocklinks +[void]
    i = i + 1
  end while
end function

/*
* Function: P_LoadThings
* Purpose: Loads and prepares data required by the gameplay and world simulation.
*/
function P_LoadThings(lump)
  data = _PS_ReadLumpBytes(lump)
  numthings = _PSET_IDiv(len(data), 10)

  i = 0
  while i < numthings
    off = i * 10
    mtype = _PS_I16LE(data, off + 6)

    spawn = true
    if gamemode != commercial then
      if mtype == 68 or mtype == 64 or mtype == 88 or mtype == 89 or
        mtype == 69 or mtype == 67 or mtype == 71 or mtype == 65 or
        mtype == 66 or mtype == 84 then
        spawn = false
      end if
    end if
    if not spawn then

      break
    end if

    mt = mapthing_t(
    _PS_I16LE(data, off + 0),
    _PS_I16LE(data, off + 2),
    _PS_I16LE(data, off + 4),
    mtype,
    _PS_I16LE(data, off + 8)
)

    if typeof(P_SpawnMapThing) == "function" then
      P_SpawnMapThing(mt)
    end if

    i = i + 1
  end while
end function

/*
* Function: P_GroupLines
* Purpose: Implements the P_GroupLines routine for the gameplay and world simulation.
*/
function P_GroupLines()

  if _PSET_IsSeq(subsectors) and _PSET_IsSeq(segs) then
    voidSec = 0
    i = 0
    while i < len(subsectors)
      ss = subsectors[i]
      if ss.firstline >= 0 and ss.firstline < len(segs) then
        seg = segs[ss.firstline]
        if seg is not void and seg.sidedef is not void then
          ss.sector = seg.sidedef.sector
          subsectors[i] = ss
        else
          voidSec = voidSec + 1
        end if
      else
        voidSec = voidSec + 1
      end if
      i = i + 1
    end while
    if typeof(devparm) != "void" and devparm then
      print "P_GroupLines: subsectors=" + len(subsectors) + " missingSector=" + voidSec
    end if
  end if

  if not _PSET_IsSeq(sectors) or not _PSET_IsSeq(lines) then
    return
  end if

  i = 0
  while i < len(sectors)
    sector = sectors[i]
    bbox =[0, 0, 0, 0]
    M_ClearBox(bbox)

    secLines =[]
    j = 0
    while j < len(lines)
      li = lines[j]
      belongs = false
      if li.frontsector == sector or li.backsector == sector then
        belongs = true
      else if _PSET_IsSeq(li.sidenum) and _PSET_IsSeq(sides) then
        si = 0
        while si < 2 and si < len(li.sidenum)
          sidx = li.sidenum[si]
          if typeof(sidx) == "int" and sidx >= 0 and sidx < len(sides) then
            sd = sides[sidx]
            if sd is not void and sd.sector == sector then
              belongs = true
              break
            end if
          end if
          si = si + 1
        end while
      end if

      if belongs then
        secLines = secLines +[li]
        M_AddToBox(bbox, li.v1.x, li.v1.y)
        M_AddToBox(bbox, li.v2.x, li.v2.y)
      end if
      j = j + 1
    end while

    sectors[i].linecount = len(secLines)
    sectors[i].lines = secLines

    sectors[i].soundorg.x =(bbox[BOXRIGHT] + bbox[BOXLEFT]) >> 1
    sectors[i].soundorg.y =(bbox[BOXTOP] + bbox[BOXBOTTOM]) >> 1

    if bmapwidth > 0 and bmapheight > 0 then
      block =(bbox[BOXTOP] - bmaporgy + MAXRADIUS) >> MAPBLOCKSHIFT
      if block >= bmapheight then block = bmapheight - 1 end if
      if block < 0 then block = 0 end if
      sectors[i].blockbox[BOXTOP] = block

      block =(bbox[BOXBOTTOM] - bmaporgy - MAXRADIUS) >> MAPBLOCKSHIFT
      if block < 0 then block = 0 end if
      if block >= bmapheight then block = bmapheight - 1 end if
      sectors[i].blockbox[BOXBOTTOM] = block

      block =(bbox[BOXRIGHT] - bmaporgx + MAXRADIUS) >> MAPBLOCKSHIFT
      if block >= bmapwidth then block = bmapwidth - 1 end if
      if block < 0 then block = 0 end if
      sectors[i].blockbox[BOXRIGHT] = block

      block =(bbox[BOXLEFT] - bmaporgx - MAXRADIUS) >> MAPBLOCKSHIFT
      if block < 0 then block = 0 end if
      if block >= bmapwidth then block = bmapwidth - 1 end if
      sectors[i].blockbox[BOXLEFT] = block
    else
      sectors[i].blockbox =[0, 0, 0, 0]
    end if

    i = i + 1
  end while
end function

/*
* Function: P_Init
* Purpose: Initializes state and dependencies for the gameplay and world simulation.
*/
function P_Init()
  if typeof(P_InitSwitchList) == "function" then P_InitSwitchList() end if
  if typeof(P_InitPicAnims) == "function" then P_InitPicAnims() end if
  if typeof(R_InitSprites) == "function" and _PSET_IsSeq(sprnames) then
    R_InitSprites(sprnames)
  end if
end function

/*
* Function: P_SetupLevel
* Purpose: Reads or updates state used by the gameplay and world simulation.
*/
function P_SetupLevel(episode, map, playermask, skill)
  global gameepisode
  global gamemap
  global gameskill
  global leveltime
  global gamestate
  global totalkills
  global totalitems
  global totalsecret
  global bodyqueslot
  global iquehead
  global iquetail
  global rejectmatrix

  gameepisode = episode
  gamemap = map
  gameskill = skill

  _PS_EnsureRuntimeArrays()
  totalkills = 0
  totalitems = 0
  totalsecret = 0

  if _PSET_IsSeq(players) then
    i = 0
    while i < MAXPLAYERS and i < len(players)
      if players[i] is void then
        players[i] = Player_MakeDefault()
      end if
      p = players[i]
      p.killcount = 0
      p.itemcount = 0
      p.secretcount = 0
      players[i] = p
      i = i + 1
    end while
  end if

  if _PSET_IsSeq(players) and consoleplayer < len(players) and players[consoleplayer] is not void then
    players[consoleplayer].viewz = 1
  end if

  if typeof(S_Start) == "function" then S_Start() end if
  if typeof(Z_FreeTags) == "function" then
    Z_FreeTags(PU_LEVEL, PU_PURGELEVEL - 1)
  end if
  if typeof(P_InitThinkers) == "function" then P_InitThinkers() end if
  if typeof(W_Reload) == "function" then W_Reload() end if

  lumpname = _PS_MapName(episode, map)
  lumpnum = W_GetNumForName(lumpname)

  leveltime = 0

  P_LoadBlockMap(lumpnum + ML_BLOCKMAP)
  P_LoadVertexes(lumpnum + ML_VERTEXES)
  P_LoadSectors(lumpnum + ML_SECTORS)
  P_LoadSideDefs(lumpnum + ML_SIDEDEFS)
  P_LoadLineDefs(lumpnum + ML_LINEDEFS)
  P_LoadSubsectors(lumpnum + ML_SSECTORS)
  P_LoadNodes(lumpnum + ML_NODES)
  P_LoadSegs(lumpnum + ML_SEGS)

  rejectmatrix = W_CacheLumpNum(lumpnum + ML_REJECT, PU_LEVEL)
  P_GroupLines()

  bodyqueslot = 0
  deathmatch_p = 0
  P_LoadThings(lumpnum + ML_THINGS)

  if deathmatch and typeof(G_DeathMatchSpawnPlayer) == "function" then
    i = 0
    while i < MAXPLAYERS
      if i < len(playeringame) and playeringame[i] then
        if i < len(players) then players[i].mo = void end if
        G_DeathMatchSpawnPlayer(i)
      end if
      i = i + 1
    end while
  end if

  iquehead = 0
  iquetail = 0

  if typeof(P_SpawnSpecials) == "function" then P_SpawnSpecials() end if
  if precache then
    if typeof(R_PrecacheLevel) == "function" then
      R_PrecacheLevel()
    end if
    if typeof(S_PrecacheLevelAudio) == "function" then
      S_PrecacheLevelAudio()
    end if
  end if

  if typeof(devparm) != "void" and devparm then
    print "P_SetupLevel E" + episode + "M" + map
  end if

  gamestate = gamestate_t.GS_LEVEL
end function



