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

  Script: r_data.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import r_defs
import r_state
import i_system
import z_zone
import m_swap
import w_wad
import doomdef
import r_local
import p_local
import doomstat
import r_sky

firstflat = 0
lastflat = 0
numflats = 0

firstpatch = 0
lastpatch = 0
numpatches = 0

firstspritelump = 0
lastspritelump = 0
numspritelumps = 0

numtextures = 0
textures = void

texturewidthmask = void
textureheight = void
texturecompositesize = void
texturecolumnlump = void
texturecolumnofs = void
texturecomposite = void
texturecolumncache = void

flattranslation = void
texturetranslation = void

spritewidth = void
spriteoffset = void
spritetopoffset = void

colormaps = void

flatmemory = 0
texturememory = 0
spritememory = 0
_r_allSpritesPrecached = false

/*
* Struct: rd_texpatch_t
* Purpose: Stores runtime data for rd texpatch type.
*/
struct rd_texpatch_t
  originx
  originy
  patch
end struct

/*
* Struct: rd_texture_t
* Purpose: Stores runtime data for rd texture type.
*/
struct rd_texture_t
  name
  width
  height
  patches
end struct

/*
* Function: _allocIntArray
* Purpose: Implements the _allocIntArray routine for the internal module support.
*/
function inline _allocIntArray(n, fill)
  a =[]
  i = 0
  while i < n
    a = a +[fill]
    i = i + 1
  end while
  return a
end function

/*
* Function: _rd_isSeq
* Purpose: Implements the _rd_isSeq routine for the internal module support.
*/
function inline _rd_isSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _rd_clamp
* Purpose: Implements the _rd_clamp routine for the internal module support.
*/
function inline _rd_clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/*
* Function: _rd_wrapColumn
* Purpose: Implements the _rd_wrapColumn routine for the internal module support.
*/
function inline _rd_wrapColumn(col, mask, width)
  c = col
  if typeof(c) != "int" then c = 0 end if
  m = mask
  if typeof(m) != "int" or m < 0 then m = width - 1 end if
  if width <= 0 then return 0 end if

  c = c & m
  if c < 0 then
    c = c % width
    if c < 0 then c = c + width end if
  end if
  if c >= width then c = c % width end if
  return c
end function

/*
* Function: _nameTo8
* Purpose: Implements the _nameTo8 routine for the internal module support.
*/
function inline _nameTo8(name)

  if len(name) <= 8 then return name end if
  outName = ""
  i = 0
  while i < 8
    outName = outName + name[i]
    i = i + 1
  end while
  return outName
end function

/*
* Function: _rd_upperName8
* Purpose: Implements the _rd_upperName8 routine for the internal module support.
*/
function _rd_upperName8(v)
  s = v
  if typeof(v) == "bytes" then
    s = decodeZ(v)
  end if
  if typeof(s) != "string" then return "" end if

  namebuf = bytes(8, 0)
  b = bytes(s)
  i = 0
  o = 0
  while i < len(b) and o < 8
    c = b[i]
    if c == 0 then break end if
    if c >= 97 and c <= 122 then c = c - 32 end if
    namebuf[o] = c
    i = i + 1
    o = o + 1
  end while
  return decodeZ(namebuf)
end function

/*
* Function: _rd_i16
* Purpose: Implements the _rd_i16 routine for the internal module support.
*/
function inline _rd_i16(b, off)
  return RDefs_I16LE(b, off)
end function

/*
* Function: _rd_i32
* Purpose: Implements the _rd_i32 routine for the internal module support.
*/
function inline _rd_i32(b, off)
  return RDefs_I32LE(b, off)
end function

/*
* Function: _rd_markPresent
* Purpose: Implements the _rd_markPresent routine for the internal module support.
*/
function inline _rd_markPresent(arr, idx)
  if not _rd_isSeq(arr) then return end if
  if typeof(idx) != "int" then return end if
  if idx < 0 or idx >= len(arr) then return end if
  arr[idx] = 1
end function

/*
* Function: _rd_enumIndex
* Purpose: Implements the _rd_enumIndex routine for the internal module support.
*/
function inline _rd_enumIndex(v, limit)
  if typeof(v) == "int" then
    if v >= 0 and v < limit then return v end if
    return -1
  end if
  n = toNumber(v)
  if typeof(n) == "int" then
    if n >= 0 and n < limit then return n end if
    return -1
  end if
  if typeof(v) != "enum" then return -1 end if

  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _rd_parseTextureLump
* Purpose: Reads or updates state used by the internal module support.
*/
function _rd_parseTextureLump(lumpname, patchlookup)
  result =[]
  lump = W_CheckNumForName(lumpname)
  if lump < 0 then return result end if

  data = W_CacheLumpNum(lump, PU_STATIC)
  if typeof(data) != "bytes" or len(data) < 4 then return result end if

  ntex = _rd_i32(data, 0)
  if typeof(ntex) != "int" or ntex < 0 then return result end if

  i = 0
  while i < ntex
    doff = 4 + i * 4
    if doff + 4 > len(data) then break end if
    off = _rd_i32(data, doff)
    if off < 0 or off + 22 > len(data) then
      i = i + 1
      continue
    end if

    name = _rd_upperName8(slice(data, off, 8))
    width = _rd_i16(data, off + 12)
    height = _rd_i16(data, off + 14)
    patchcount = _rd_i16(data, off + 20)
    if width <= 0 then width = 1 end if
    if height <= 0 then height = 1 end if
    if patchcount < 0 then patchcount = 0 end if

    patches =[]
    poff = off + 22
    p = 0
    while p < patchcount and poff + 10 <= len(data)
      ox = _rd_i16(data, poff + 0)
      oy = _rd_i16(data, poff + 2)
      pidx = _rd_i16(data, poff + 4)
      plump = -1
      if pidx >= 0 and typeof(patchlookup) == "array" and pidx < len(patchlookup) then
        plump = patchlookup[pidx]
      end if
      if plump >= 0 then
        patches = patches +[rd_texpatch_t(ox, oy, plump)]
      end if
      p = p + 1
      poff = poff + 10
    end while

    result = result +[rd_texture_t(name, width, height, patches)]
    i = i + 1
  end while
  return result
end function

/*
* Function: _rd_drawPatchColumnToCanvas
* Purpose: Draws or renders output for the internal module support.
*/
function _rd_drawPatchColumnToCanvas(patchBytes, colOff, canvas, texW, texH, dstX, originY)
  off = colOff
  while off >= 0 and off < len(patchBytes)
    topdelta = patchBytes[off]
    if topdelta == 255 then break end if
    if off + 3 >= len(patchBytes) then break end if

    run = patchBytes[off + 1]
    src = off + 3
    i = 0
    while i < run and(src + i) < len(patchBytes)
      dstY = originY + topdelta + i
      if dstY >= 0 and dstY < texH and dstX >= 0 and dstX < texW then
        canvas[dstY * texW + dstX] = patchBytes[src + i]
      end if
      i = i + 1
    end while

    off = off + run + 4
  end while
end function

/*
* Function: _rd_generateTextureComposite
* Purpose: Implements the _rd_generateTextureComposite routine for the internal module support.
*/
function _rd_generateTextureComposite(texnum)
  global texturecomposite
  global texturecolumncache
  global texturecompositesize

  if not _rd_isSeq(textures) or texnum < 0 or texnum >= len(textures) then return end if

  tex = textures[texnum]
  if tex is void then return end if
  texW = tex.width
  texH = tex.height
  if texW <= 0 or texH <= 0 then return end if

  canvas = bytes(texW * texH, 0)

  if typeof(tex.patches) == "array" then
    for each tp in tex.patches
      if tp is void then continue end if
      patchBytes = W_CacheLumpNum(tp.patch, PU_CACHE)
      if typeof(patchBytes) != "bytes" then continue end if

      pw = Patch_Width(patchBytes)
      if typeof(pw) != "int" or pw <= 0 then continue end if

      x = 0
      while x < pw
        dstX = tp.originx + x
        if dstX >= 0 and dstX < texW then
          colOff = Patch_ColumnOffset(patchBytes, x)
          if typeof(colOff) == "int" and colOff >= 0 and colOff < len(patchBytes) then
            _rd_drawPatchColumnToCanvas(patchBytes, colOff, canvas, texW, texH, dstX, tp.originy)
          end if
        end if
        x = x + 1
      end while
    end for
  end if

  cols =[]
  x = 0
  while x < texW
    col = bytes(texH, 0)
    y = 0
    while y < texH
      col[y] = canvas[y * texW + x]
      y = y + 1
    end while
    cols = cols +[col]
    x = x + 1
  end while

  texturecomposite[texnum] = canvas
  if _rd_isSeq(texturecolumncache) and texnum < len(texturecolumncache) then
    texturecolumncache[texnum] = cols
  end if
  if _rd_isSeq(texturecompositesize) and texnum < len(texturecompositesize) then
    texturecompositesize[texnum] = texW * texH
  end if
end function

/*
* Function: R_DrawColumnInCache
* Purpose: Retrieves and caches data for the renderer.
*/
function R_DrawColumnInCache(patch, cache, originy, cacheheight)
  if typeof(patch) != "bytes" or typeof(cache) != "bytes" then return end if

  off = 0
  while off >= 0 and off < len(patch)
    topdelta = patch[off]
    if topdelta == 255 then break end if
    if off + 3 >= len(patch) then break end if

    run = patch[off + 1]
    src = off + 3
    pos = originy + topdelta

    if pos < 0 then
      src = src - pos
      run = run + pos
      pos = 0
    end if
    if pos + run > cacheheight then
      run = cacheheight - pos
    end if

    i = 0
    while i < run and(src + i) < len(patch) and(pos + i) < len(cache)
      cache[pos + i] = patch[src + i]
      i = i + 1
    end while

    off = off + patch[off + 1] + 4
  end while
end function

/*
* Function: _rd_drawColumnInCacheAt
* Purpose: Retrieves and caches data for the internal module support.
*/
function _rd_drawColumnInCacheAt(patchBytes, colOff, cache, cacheOff, originy, cacheheight)
  if typeof(patchBytes) != "bytes" or typeof(cache) != "bytes" then return end if
  if typeof(colOff) != "int" or colOff < 0 or colOff >= len(patchBytes) then return end if
  if typeof(cacheOff) != "int" or cacheOff < 0 or cacheOff >= len(cache) then return end if

  off = colOff
  while off >= 0 and off < len(patchBytes)
    topdelta = patchBytes[off]
    if topdelta == 255 then break end if
    if off + 3 >= len(patchBytes) then break end if

    run = patchBytes[off + 1]
    src = off + 3
    pos = originy + topdelta

    if pos < 0 then
      src = src - pos
      run = run + pos
      pos = 0
    end if
    if pos + run > cacheheight then
      run = cacheheight - pos
    end if

    i = 0
    while i < run and(src + i) < len(patchBytes) and(cacheOff + pos + i) < len(cache)
      cache[cacheOff + pos + i] = patchBytes[src + i]
      i = i + 1
    end while

    off = off + patchBytes[off + 1] + 4
  end while
end function

/*
* Function: R_GenerateComposite
* Purpose: Implements the R_GenerateComposite routine for the renderer.
*/
function R_GenerateComposite(texnum)
  global texturecomposite

  if not _rd_isSeq(textures) or texnum < 0 or texnum >= len(textures) then return end if
  if not _rd_isSeq(texturecolumnlump) or texnum >= len(texturecolumnlump) then return end if
  if not _rd_isSeq(texturecolumnofs) or texnum >= len(texturecolumnofs) then return end if
  if not _rd_isSeq(texturecompositesize) or texnum >= len(texturecompositesize) then return end if

  tex = textures[texnum]
  if tex is void then return end if
  texW = _rd_clamp(tex.width, 1, 32767)
  texH = _rd_clamp(tex.height, 1, 32767)
  compsize = _rd_clamp(texturecompositesize[texnum], 0, 1 << 26)

  if compsize <= 0 then
    if _rd_isSeq(texturecomposite) and texnum < len(texturecomposite) then
      texturecomposite[texnum] = bytes(0, 0)
    end if
    return
  end if

  block = bytes(compsize, 0)
  collump = texturecolumnlump[texnum]
  colofs = texturecolumnofs[texnum]
  if not _rd_isSeq(collump) or not _rd_isSeq(colofs) then return end if

  if _rd_isSeq(tex.patches) then
    for each tp in tex.patches
      if tp is void then continue end if
      patchBytes = W_CacheLumpNum(tp.patch, PU_CACHE)
      if typeof(patchBytes) != "bytes" then continue end if
      pw = Patch_Width(patchBytes)
      if typeof(pw) != "int" or pw <= 0 then continue end if

      x1 = tp.originx
      x2 = x1 + pw
      x = x1
      if x < 0 then x = 0 end if
      if x2 > texW then x2 = texW end if

      while x < x2
        if x >= 0 and x < len(collump) and collump[x] < 0 and x < len(colofs) then
          colOff = Patch_ColumnOffset(patchBytes, x - x1)
          cacheOff = colofs[x]
          _rd_drawColumnInCacheAt(patchBytes, colOff, block, cacheOff, tp.originy, texH)
        end if
        x = x + 1
      end while
    end for
  end if

  if _rd_isSeq(texturecomposite) and texnum < len(texturecomposite) then
    texturecomposite[texnum] = block
  end if
end function

/*
* Function: R_GenerateLookup
* Purpose: Implements the R_GenerateLookup routine for the renderer.
*/
function R_GenerateLookup(texnum)
  global texturecolumnlump
  global texturecolumnofs
  global texturecomposite
  global texturecompositesize

  if not _rd_isSeq(textures) or texnum < 0 or texnum >= len(textures) then return end if
  if not _rd_isSeq(texturecolumnlump) or texnum >= len(texturecolumnlump) then return end if
  if not _rd_isSeq(texturecolumnofs) or texnum >= len(texturecolumnofs) then return end if
  if not _rd_isSeq(texturecompositesize) or texnum >= len(texturecompositesize) then return end if
  if not _rd_isSeq(texturecomposite) or texnum >= len(texturecomposite) then return end if

  tex = textures[texnum]
  if tex is void then return end if
  texW = _rd_clamp(tex.width, 1, 32767)
  texH = _rd_clamp(tex.height, 1, 32767)

  collump = texturecolumnlump[texnum]
  colofs = texturecolumnofs[texnum]
  if not _rd_isSeq(collump) or len(collump) != texW then
    collump = _allocIntArray(texW, -1)
  else
    x = 0
    while x < texW
      collump[x] = -1
      x = x + 1
    end while
  end if
  if not _rd_isSeq(colofs) or len(colofs) != texW then
    colofs = _allocIntArray(texW, 0)
  else
    x = 0
    while x < texW
      colofs[x] = 0
      x = x + 1
    end while
  end if

  patchcount = _allocIntArray(texW, 0)
  texturecomposite[texnum] = bytes(0, 0)
  texturecompositesize[texnum] = 0

  if _rd_isSeq(tex.patches) then
    for each tp in tex.patches
      if tp is void then continue end if
      patchBytes = W_CacheLumpNum(tp.patch, PU_CACHE)
      if typeof(patchBytes) != "bytes" then continue end if
      pw = Patch_Width(patchBytes)
      if typeof(pw) != "int" or pw <= 0 then continue end if

      x1 = tp.originx
      x2 = x1 + pw
      x = x1
      if x < 0 then x = 0 end if
      if x2 > texW then x2 = texW end if

      while x < x2
        patchcount[x] = patchcount[x] + 1
        collump[x] = tp.patch
        colofs[x] = Patch_ColumnOffset(patchBytes, x - x1) + 3
        x = x + 1
      end while
    end for
  end if

  x = 0
  while x < texW
    if patchcount[x] <= 0 then
      collump[x] = -1
      colofs[x] = 0
    else if patchcount[x] > 1 then
      collump[x] = -1
      colofs[x] = texturecompositesize[texnum]
      if texturecompositesize[texnum] >(0x10000 - texH) then
        texturecompositesize[texnum] = 0x10000 - texH
      end if
      texturecompositesize[texnum] = texturecompositesize[texnum] + texH
    end if
    x = x + 1
  end while

  texturecolumnlump[texnum] = collump
  texturecolumnofs[texnum] = colofs
end function

/*
* Function: R_InitFlats
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitFlats()
  global firstflat
  global lastflat
  global numflats
  global flattranslation

  firstflat = W_GetNumForName("F_START") + 1
  lastflat = W_GetNumForName("F_END") - 1
  numflats = lastflat - firstflat + 1

  flattranslation = _allocIntArray(numflats + 1, 0)
  i = 0
  while i < numflats
    flattranslation[i] = i
    i = i + 1
  end while
end function

/*
* Function: R_FlatNumForName
* Purpose: Implements the R_FlatNumForName routine for the renderer.
*/
function R_FlatNumForName(name)

  n = _nameTo8(name)
  lump = W_CheckNumForName(n)
  if lump < 0 then
    I_Error("R_FlatNumForName: " + n + " not found")
    return 0
  end if

  return lump - firstflat
end function

/*
* Function: R_GetFlat
* Purpose: Reads or updates state used by the renderer.
*/
function R_GetFlat(flatnum)
  if typeof(flatnum) != "int" then return void end if
  if typeof(flattranslation) == "array" and flatnum >= 0 and flatnum < len(flattranslation) then
    flatnum = flattranslation[flatnum]
  end if
  lump = firstflat + flatnum
  if lump < firstflat or lump > lastflat then return void end if
  return W_CacheLumpNum(lump, PU_CACHE)
end function

/*
* Function: R_InitSpriteLumps
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitSpriteLumps()
  global firstspritelump
  global lastspritelump
  global numspritelumps
  global spritewidth
  global spriteoffset
  global spritetopoffset

  firstspritelump = W_GetNumForName("S_START") + 1
  lastspritelump = W_GetNumForName("S_END") - 1
  numspritelumps = lastspritelump - firstspritelump + 1

  spritewidth = _allocIntArray(numspritelumps, 0)
  spriteoffset = _allocIntArray(numspritelumps, 0)
  spritetopoffset = _allocIntArray(numspritelumps, 0)

  i = 0
  while i < numspritelumps
    patchBytes = W_CacheLumpNum(firstspritelump + i, PU_CACHE)
    if typeof(patchBytes) == "bytes" then
      w = Patch_Width(patchBytes)
      lo = Patch_LeftOffset(patchBytes)
      topOff = Patch_TopOffset(patchBytes)
      spritewidth[i] = w << FRACBITS
      spriteoffset[i] = lo << FRACBITS
      spritetopoffset[i] = topOff << FRACBITS
    end if
    i = i + 1
  end while
end function

/*
* Function: R_InitColormaps
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitColormaps()
  global colormaps

  lump = W_GetNumForName("COLORMAP")

  colormaps = W_CacheLumpNum(lump, PU_STATIC)
end function

/*
* Function: R_InitTextures
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitTextures()
  global numtextures
  global textures
  global texturewidthmask
  global textureheight
  global texturecompositesize
  global texturecolumnlump
  global texturecolumnofs
  global texturecomposite
  global texturecolumncache
  global texturetranslation

  global firstpatch
  firstpatch = W_CheckNumForName("P_START")
  global lastpatch
  lastpatch = W_CheckNumForName("P_END")
  if firstpatch >= 0 then firstpatch = firstpatch + 1 end if
  if lastpatch >= 0 then lastpatch = lastpatch - 1 end if
  if firstpatch >= 0 and lastpatch >= firstpatch then
    global numpatches
    numpatches = lastpatch - firstpatch + 1
  else
    numpatches = 0
  end if

  patchlookup =[]
  pnamesLump = W_CheckNumForName("PNAMES")
  if pnamesLump >= 0 then
    pnames = W_CacheLumpNum(pnamesLump, PU_STATIC)
    if typeof(pnames) == "bytes" and len(pnames) >= 4 then
      nummappatches = _rd_i32(pnames, 0)
      if typeof(nummappatches) == "int" and nummappatches > 0 then
        i = 0
        while i < nummappatches
          off = 4 + i * 8
          if off + 8 > len(pnames) then break end if
          pname = _rd_upperName8(slice(pnames, off, 8))
          patchlookup = patchlookup +[W_CheckNumForName(pname)]
          i = i + 1
        end while
      end if
    end if
  end if

  textures = _rd_parseTextureLump("TEXTURE1", patchlookup)
  t2 = _rd_parseTextureLump("TEXTURE2", patchlookup)
  if typeof(t2) == "array" and len(t2) > 0 then
    textures = textures + t2
  end if
  if typeof(textures) != "array" then textures =[] end if
  numtextures = len(textures)

  texturewidthmask =[]
  textureheight =[]
  texturecompositesize =[]
  texturecolumnlump =[]
  texturecolumnofs =[]
  texturecomposite =[]
  texturecolumncache =[]
  texturetranslation =[]

  i = 0
  while i < numtextures
    tex = textures[i]
    w = tex.width
    h = tex.height
    if w <= 0 then w = 1 end if
    if h <= 0 then h = 1 end if

    m = 1
    while (m << 1) <= w
      m = m << 1
    end while
    m = m - 1
    if m < 0 then m = 0 end if

    texturewidthmask = texturewidthmask +[m]
    textureheight = textureheight +[h << FRACBITS]
    texturecompositesize = texturecompositesize +[0]

    cl =[]
    co =[]
    x = 0
    while x < w
      cl = cl +[-1]
      co = co +[0]
      x = x + 1
    end while
    texturecolumnlump = texturecolumnlump +[cl]
    texturecolumnofs = texturecolumnofs +[co]
    texturecomposite = texturecomposite +[void]
    cc =[]
    x = 0
    while x < w
      cc = cc +[void]
      x = x + 1
    end while
    texturecolumncache = texturecolumncache +[cc]
    texturetranslation = texturetranslation +[i]

    i = i + 1
  end while

  i = 0
  while i < numtextures
    R_GenerateLookup(i)
    i = i + 1
  end while
end function

/*
* Function: _rd_ensureColumnCache
* Purpose: Retrieves and caches data for the internal module support.
*/
function inline _rd_ensureColumnCache(tex, width)
  if not _rd_isSeq(texturecolumncache) then return void end if
  if typeof(tex) != "int" or tex < 0 or tex >= len(texturecolumncache) then return void end if
  if typeof(width) != "int" or width <= 0 then return void end if

  cols = texturecolumncache[tex]
  if _rd_isSeq(cols) and len(cols) == width then
    return cols
  end if

  cols =[]
  i = 0
  while i < width
    cols = cols +[void]
    i = i + 1
  end while
  texturecolumncache[tex] = cols
  return cols
end function

/*
* Function: R_GetColumn
* Purpose: Reads or updates state used by the renderer.
*/
function R_GetColumn(tex, col)
  if not _rd_isSeq(textures) then return void end if
  if typeof(tex) != "int" or tex < 0 or tex >= len(textures) then return void end if
  t = textures[tex]
  if t is void then return void end if
  w = t.width
  if typeof(w) != "int" or w <= 0 then return void end if
  m = 0
  if _rd_isSeq(texturewidthmask) and tex < len(texturewidthmask) then
    m = texturewidthmask[tex]
  end if
  c = _rd_wrapColumn(col, m, w)

  cols = _rd_ensureColumnCache(tex, w)
  if _rd_isSeq(cols) and c >= 0 and c < len(cols) and typeof(cols[c]) == "bytes" then
    return cols[c]
  end if

  h = _rd_clamp(t.height, 1, 32767)
  if _rd_isSeq(texturecolumnlump) and tex < len(texturecolumnlump) and _rd_isSeq(texturecolumnofs) and tex < len(texturecolumnofs) then
    collump = texturecolumnlump[tex]
    colofs = texturecolumnofs[tex]
    if _rd_isSeq(collump) and _rd_isSeq(colofs) and c >= 0 and c < len(collump) and c < len(colofs) then
      lump = collump[c]
      ofs = colofs[c]

      if typeof(lump) == "int" and lump >= 0 and typeof(ofs) == "int" then
        patchBytes = W_CacheLumpNum(lump, PU_CACHE)
        if typeof(patchBytes) == "bytes" then
          colBytes = bytes(h, 0)
          _rd_drawColumnInCacheAt(patchBytes, ofs - 3, colBytes, 0, 0, h)
          if _rd_isSeq(cols) and c < len(cols) then cols[c] = colBytes end if
          return colBytes
        end if
      end if

      if typeof(ofs) == "int" then
        if _rd_isSeq(texturecomposite) and tex < len(texturecomposite) then
          comp = texturecomposite[tex]
          if typeof(comp) != "bytes" or len(comp) == 0 then
            R_GenerateComposite(tex)
            comp = texturecomposite[tex]
          end if
          if typeof(comp) == "bytes" and ofs >= 0 and(ofs + h) <= len(comp) then
            colBytes = slice(comp, ofs, h)
            if _rd_isSeq(cols) and c < len(cols) then cols[c] = colBytes end if
            return colBytes
          end if
        end if
      end if
    end if
  end if

  _rd_generateTextureComposite(tex)
  if not _rd_isSeq(texturecolumncache) or tex >= len(texturecolumncache) then return void end if
  cols = texturecolumncache[tex]
  if not _rd_isSeq(cols) or len(cols) == 0 then return void end if
  if c < 0 then c = 0 end if
  if c >= len(cols) then c = len(cols) - 1 end if
  if typeof(cols[c]) == "bytes" then return cols[c] end if
  return void
end function

/*
* Function: R_GetMaskedColumnRaw
* Purpose: Reads or updates state used by the renderer.
*/
function R_GetMaskedColumnRaw(tex, col)
  if not _rd_isSeq(textures) then return void end if
  if typeof(tex) != "int" or tex < 0 or tex >= len(textures) then return void end if
  if not _rd_isSeq(texturecolumnlump) or tex >= len(texturecolumnlump) then return void end if
  if not _rd_isSeq(texturecolumnofs) or tex >= len(texturecolumnofs) then return void end if

  t = textures[tex]
  if t is void then return void end if
  w = _rd_clamp(t.width, 1, 32767)
  m = 0
  if _rd_isSeq(texturewidthmask) and tex < len(texturewidthmask) then
    m = texturewidthmask[tex]
  end if
  c = _rd_wrapColumn(col, m, w)

  collump = texturecolumnlump[tex]
  colofs = texturecolumnofs[tex]
  if not _rd_isSeq(collump) or not _rd_isSeq(colofs) then return void end if
  if c < 0 or c >= len(collump) or c >= len(colofs) then return void end if

  lump = collump[c]
  ofs = colofs[c]
  if typeof(lump) != "int" or lump < 0 then return void end if
  if typeof(ofs) != "int" then return void end if

  patchBytes = W_CacheLumpNum(lump, PU_CACHE)
  if typeof(patchBytes) != "bytes" then return void end if
  start = ofs - 3
  if start < 0 or start >= len(patchBytes) then return void end if
  return [patchBytes, start]
end function

/*
* Function: R_CheckTextureNumForName
* Purpose: Evaluates conditions and returns a decision for the renderer.
*/
function R_CheckTextureNumForName(name)
  n = _rd_upperName8(name)
  if len(n) > 0 and bytes(n)[0] == 45 then

    return 0
  end if
  if typeof(textures) != "array" then return -1 end if
  i = 0
  while i < len(textures)
    t = textures[i]
    if t is not void and t.name == n then
      return i
    end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: R_TextureNumForName
* Purpose: Implements the R_TextureNumForName routine for the renderer.
*/
function R_TextureNumForName(name)
  n = R_CheckTextureNumForName(name)
  if n < 0 then
    if typeof(devparm) != "void" and devparm then
      print "R_TextureNumForName: missing " + _rd_upperName8(name)
    end if
    return 0
  end if
  return n
end function

/*
* Function: R_PrecacheLevel
* Purpose: Retrieves and caches data for the renderer.
*/
function R_PrecacheLevel()
  global flatmemory
  global texturememory
  global spritememory

  if typeof(demoplayback) == "bool" and demoplayback then return end if

  flatmemory = 0
  texturememory = 0
  spritememory = 0

  if typeof(numflats) == "int" and numflats > 0 then
    flatpresent = _allocIntArray(numflats, 0)
    if _rd_isSeq(sectors) and typeof(numsectors) == "int" then
      i = 0
      while i < numsectors and i < len(sectors)
        sec = sectors[i]
        if sec is not void then
          _rd_markPresent(flatpresent, sec.floorpic)
          _rd_markPresent(flatpresent, sec.ceilingpic)
        end if
        i = i + 1
      end while
    end if

    i = 0
    while i < numflats
      if flatpresent[i] != 0 then
        lump = firstflat + i
        if _rd_isSeq(lumpinfo) and lump >= 0 and lump < len(lumpinfo) and lumpinfo[lump] is not void and typeof(lumpinfo[lump].size) == "int" then
          flatmemory = flatmemory + lumpinfo[lump].size
        end if
        _ = W_CacheLumpNum(lump, PU_CACHE)
      end if
      i = i + 1
    end while
  end if

  if typeof(numtextures) == "int" and numtextures > 0 then
    texturepresent = _allocIntArray(numtextures, 0)
    if _rd_isSeq(sides) and typeof(numsides) == "int" then
      i = 0
      while i < numsides and i < len(sides)
        sd = sides[i]
        if sd is not void then
          _rd_markPresent(texturepresent, sd.toptexture)
          _rd_markPresent(texturepresent, sd.midtexture)
          _rd_markPresent(texturepresent, sd.bottomtexture)
        end if
        i = i + 1
      end while
    end if
    _rd_markPresent(texturepresent, skytexture)

    i = 0
    while i < numtextures and i < len(textures)
      if texturepresent[i] == 0 then
        i = i + 1
        continue
      end if

      tex = textures[i]
      if tex is void or not _rd_isSeq(tex.patches) then
        i = i + 1
        continue
      end if

      j = 0
      while j < len(tex.patches)
        tp = tex.patches[j]
        if tp is not void and typeof(tp.patch) == "int" and tp.patch >= 0 then
          lump = tp.patch
          if _rd_isSeq(lumpinfo) and lump < len(lumpinfo) and lumpinfo[lump] is not void and typeof(lumpinfo[lump].size) == "int" then
            texturememory = texturememory + lumpinfo[lump].size
          end if
          _ = W_CacheLumpNum(lump, PU_CACHE)
        end if
        j = j + 1
      end while

      i = i + 1
    end while

    i = 0
    while i < numtextures and i < len(textures) and i < len(texturepresent)
      if texturepresent[i] != 0 then
        tex = textures[i]
        if tex is not void and typeof(tex.width) == "int" and tex.width > 0 then
          w = _rd_clamp(tex.width, 1, 4096)
          c = 0
          while c < w
            _ = R_GetColumn(i, c)
            c = c + 1
          end while
        end if
      end if
      i = i + 1
    end while
  end if

  spritecount = 0
  if _rd_isSeq(sprites) then
    spritecount = len(sprites)
  else if typeof(numsprites) == "int" and numsprites > 0 then
    spritecount = numsprites
  end if

  if spritecount > 0 then
    spritepresent = _allocIntArray(spritecount, 0)

    if thinkercap is not void and thinkercap.next is not void then
      cur = thinkercap.next
      guard = 0
      while cur is not void and cur != thinkercap and guard < 131072
        mo = void
        isMobjThinker = false
        if cur.func is not void and typeof(cur.func.acp1) == "function" and cur.func.acp1 == P_MobjThinker then
          isMobjThinker = true
        end if
        if isMobjThinker then
          if typeof(P_ResolveThinkerOwner) == "function" then
            mo = P_ResolveThinkerOwner(cur)
          end if
          if mo is void and typeof(_PM_ResolveThinkerOwner) == "function" then
            mo = _PM_ResolveThinkerOwner(cur)
          end if
        end if

        if mo is not void and typeof(mo.sprite) != "void" then
          sidx = _rd_enumIndex(mo.sprite, spritecount)
          if sidx >= 0 then spritepresent[sidx] = 1 end if
        end if

        cur = cur.next
        guard = guard + 1
      end while
    end if

    global _r_allSpritesPrecached
    if not _r_allSpritesPrecached and _rd_isSeq(spritepresent) then

      i = 0
      while i < spritecount and i < len(spritepresent)
        spritepresent[i] = 1
        i = i + 1
      end while
      _r_allSpritesPrecached = true
    end if

    i = 0
    while i < spritecount and i < len(sprites)
      if spritepresent[i] == 0 then
        i = i + 1
        continue
      end if

      sd = sprites[i]
      if sd is void or not _rd_isSeq(sd.spriteframes) or typeof(sd.numframes) != "int" or sd.numframes <= 0 then
        i = i + 1
        continue
      end if

      j = 0
      while j < sd.numframes and j < len(sd.spriteframes)
        sf = sd.spriteframes[j]
        if sf is not void and _rd_isSeq(sf.lump) then
          k = 0
          while k < 8 and k < len(sf.lump)
            loff = sf.lump[k]
            if typeof(loff) == "int" and loff >= 0 and loff < numspritelumps then
              lump = firstspritelump + loff
              if _rd_isSeq(lumpinfo) and lump >= 0 and lump < len(lumpinfo) and lumpinfo[lump] is not void and typeof(lumpinfo[lump].size) == "int" then
                spritememory = spritememory + lumpinfo[lump].size
              end if
              _ = W_CacheLumpNum(lump, PU_CACHE)
            end if
            k = k + 1
          end while
        end if
        j = j + 1
      end while

      i = i + 1
    end while
  end if
end function

/*
* Function: R_InitData
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitData()
  R_InitTextures()
  R_InitFlats()
  R_InitSpriteLumps()
  R_InitColormaps()
  R_InitSkyMap()
end function



