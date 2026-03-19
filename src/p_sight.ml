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

  Script: p_sight.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import doomdef
import i_system
import p_local
import p_maputl
import r_state
import doomdata
import m_fixed

sightzstart = 0
topslope = 0
bottomslope = 0

strace = divline_t(0, 0, 0, 0)
t2x = 0
t2y = 0

sightcounts =[0, 0]

/*
* Function: _PSI_SectorIndex
* Purpose: Implements the _PSI_SectorIndex routine for the internal module support.
*/
function _PSI_SectorIndex(sec)
  if sec is void then return -1 end if
  if typeof(sectors) != "array" then return -1 end if
  i = 0
  while i < len(sectors)
    if sectors[i] == sec then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _PSI_GetRejectByte
* Purpose: Reads or updates state used by the internal module support.
*/
function _PSI_GetRejectByte(idx)
  if idx < 0 then return 0 end if

  if typeof(rejectmatrix) == "bytes" then
    if idx >= len(rejectmatrix) then return 0 end if
    return rejectmatrix[idx]
  end if

  if typeof(rejectmatrix) == "array" then
    if idx >= len(rejectmatrix) then return 0 end if
    b = rejectmatrix[idx]
    if typeof(b) == "int" or typeof(b) == "float" then return b end if
  end if

  return 0
end function

/*
* Function: P_DivlineSide
* Purpose: Implements the P_DivlineSide routine for the gameplay and world simulation.
*/
function inline P_DivlineSide(x, y, node)
  if node is void then return 0 end if

  if node.dx == 0 then
    if x == node.x then return 2 end if
    if x <= node.x then
      if node.dy > 0 then return 1 else return 0 end if
    end if
    if node.dy < 0 then return 1 else return 0 end if
  end if

  if node.dy == 0 then

    // Vanilla source has a known typo here (x == node->y); keep y-check for stable LOS.
    if y == node.y then return 2 end if
    if y <= node.y then
      if node.dx < 0 then return 1 else return 0 end if
    end if
    if node.dx > 0 then return 1 else return 0 end if
  end if

  dx = x - node.x
  dy = y - node.y

  left =(node.dy >> FRACBITS) *(dx >> FRACBITS)
  right =(dy >> FRACBITS) *(node.dx >> FRACBITS)

  if right < left then return 0 end if
  if left == right then return 2 end if
  return 1
end function

/*
* Function: P_InterceptVector2
* Purpose: Implements the P_InterceptVector2 routine for the gameplay and world simulation.
*/
function inline P_InterceptVector2(v2, v1)
  den = FixedMul(v1.dy >> 8, v2.dx) - FixedMul(v1.dx >> 8, v2.dy)
  if den == 0 then return 0 end if

  num = FixedMul((v1.x - v2.x) >> 8, v1.dy) + FixedMul((v2.y - v1.y) >> 8, v1.dx)
  frac = FixedDiv(num, den)
  return frac
end function

/*
* Function: P_CrossSubsector
* Purpose: Implements the P_CrossSubsector routine for the gameplay and world simulation.
*/
function P_CrossSubsector(num)
  if typeof(subsectors) != "array" or typeof(segs) != "array" then return false end if
  if num >= len(subsectors) then
    if typeof(I_Error) == "function" then I_Error("P_CrossSubsector: bad subsector " + num) end if
    return false
  end if

  sub = subsectors[num]

  count = sub.numlines
  segi = sub.firstline
  while count > 0
    seg = segs[segi]
    line = seg.linedef

    if line.validcount != validcount then
      line.validcount = validcount

      v1 = line.v1
      v2 = line.v2
      s1 = P_DivlineSide(v1.x, v1.y, strace)
      s2 = P_DivlineSide(v2.x, v2.y, strace)

      if s1 != s2 then
        divl = divline_t(v1.x, v1.y, v2.x - v1.x, v2.y - v1.y)
        s1 = P_DivlineSide(strace.x, strace.y, divl)
        s2 = P_DivlineSide(t2x, t2y, divl)

        if s1 != s2 then
          if (line.flags & ML_TWOSIDED) == 0 then return false end if

          front = seg.frontsector
          back = seg.backsector

          if front.floorheight != back.floorheight or front.ceilingheight != back.ceilingheight then
            if front.ceilingheight < back.ceilingheight then
              opentop = front.ceilingheight
            else
              opentop = back.ceilingheight
            end if

            if front.floorheight > back.floorheight then
              openbottom = front.floorheight
            else
              openbottom = back.floorheight
            end if

            if openbottom >= opentop then return false end if

            frac = P_InterceptVector2(strace, divl)

            if front.floorheight != back.floorheight then
              slope = FixedDiv(openbottom - sightzstart, frac)
              if slope > bottomslope then bottomslope = slope end if
            end if

            if front.ceilingheight != back.ceilingheight then
              slope = FixedDiv(opentop - sightzstart, frac)
              if slope < topslope then topslope = slope end if
            end if

            if topslope <= bottomslope then return false end if
          end if
        end if
      end if
    end if

    count = count - 1
    segi = segi + 1
  end while

  return true
end function

/*
* Function: P_CrossBSPNode
* Purpose: Implements the P_CrossBSPNode routine for the gameplay and world simulation.
*/
function P_CrossBSPNode(bspnum)
  if (bspnum & NF_SUBSECTOR) != 0 then
    if bspnum == -1 then
      return P_CrossSubsector(0)
    else
      return P_CrossSubsector(bspnum &(~NF_SUBSECTOR))
    end if
  end if

  if typeof(nodes) != "array" or bspnum < 0 or bspnum >= len(nodes) then
    if typeof(I_Error) == "function" then I_Error("P_CrossBSPNode: bad node " + bspnum) end if
    return false
  end if

  bsp = nodes[bspnum]
  if bsp is void then return false end if

  div = divline_t(bsp.x, bsp.y, bsp.dx, bsp.dy)

  side = P_DivlineSide(strace.x, strace.y, div)
  if side == 2 then side = 0 end if

  if not P_CrossBSPNode(bsp.children[side]) then return false end if

  if side == P_DivlineSide(t2x, t2y, div) then
    return true
  end if

  return P_CrossBSPNode(bsp.children[side ^ 1])
end function

/*
* Function: P_CheckSight
* Purpose: Evaluates conditions and returns a decision for the gameplay and world simulation.
*/
function P_CheckSight(t1, t2)
  global sightzstart
  global topslope
  global bottomslope
  global strace
  global t2x
  global t2y
  global sightcounts
  global validcount

  if t1 is void or t2 is void then return false end if

  if t1.subsector is void or t1.subsector.sector is void then return false end if
  if t2.subsector is void or t2.subsector.sector is void then return false end if

  s1 = _PSI_SectorIndex(t1.subsector.sector)
  s2 = _PSI_SectorIndex(t2.subsector.sector)
  if s1 >= 0 and s2 >= 0 and numsectors > 0 then
    pnum = s1 * numsectors + s2
    bytenum = pnum >> 3
    bitnum = 1 <<(pnum & 7)

    rb = _PSI_GetRejectByte(bytenum)
    if (rb & bitnum) != 0 then
      if typeof(sightcounts) != "array" or len(sightcounts) < 2 then sightcounts =[0, 0] end if
      sightcounts[0] = sightcounts[0] + 1
      return false
    end if
  end if

  if typeof(sightcounts) != "array" or len(sightcounts) < 2 then sightcounts =[0, 0] end if
  sightcounts[1] = sightcounts[1] + 1

  validcount = validcount + 1

  sightzstart = t1.z + t1.height -(t1.height >> 2)
  topslope =(t2.z + t2.height) - sightzstart
  bottomslope = t2.z - sightzstart

  strace = divline_t(t1.x, t1.y, t2.x - t1.x, t2.y - t1.y)
  t2x = t2.x
  t2y = t2.y

  if numnodes <= 0 then return P_CrossSubsector(0) end if

  return P_CrossBSPNode(numnodes - 1)
end function



