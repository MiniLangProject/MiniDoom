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

  Script: z_zone.ml
  Purpose: Implements zone-style memory tagging and allocation lifecycle helpers.
*/
import i_system
import doomdef

const PU_STATIC = 1
const PU_SOUND = 2
const PU_MUSIC = 3
const PU_DAVE = 4
const PU_LEVEL = 50
const PU_LEVSPEC = 51

const PU_PURGELEVEL = 100
const PU_CACHE = 101

/*
* Struct: memblock_t
* Purpose: Describes one contiguous zone range with owner reference, purge tag, integrity marker, and indices in the address-ordered block list.
*/
struct memblock_t
  start
  size
  user
  tag
  id
  next
  prev
end struct

const ZONEID = 0x1d4a11
const MINFRAGMENT = 64
const _Z_NULL_OWNER_PTR = -1

const _Z_HDR = 0

_Z_buf = void
_Z_size = 0

_Z_blocks = void
_Z_blocklist = 0
_Z_rover = 0

/*
* Function: _Z_Get
* Purpose: Lazily initializes the zone and safely resolves an internal block-table index.
*/
function inline _Z_Get(i)
  if typeof(_Z_blocks) != "array" then
    if typeof(Z_Init) == "function" then Z_Init() end if
  end if
  if typeof(_Z_blocks) != "array" then return void end if
  if typeof(i) != "int" or i < 0 or i >= len(_Z_blocks) then return void end if
  return _Z_blocks[i]
end function

/*
* Function: _Z_Set
* Purpose: Updates a zone allocation block in the zone memory table.
*/
function inline _Z_Set(i, b)
  if typeof(_Z_blocks) != "array" then return end if
  if typeof(i) != "int" or i < 0 then return end if
  if i >= len(_Z_blocks) then return end if
  _Z_blocks[i] = b
end function

/*
* Function: _Z_IsFree
* Purpose: Treats a block as free exactly when it has no owner marker.
*/
function inline _Z_IsFree(i)
  b = _Z_Get(i)
  return typeof(b.user) == "void"
end function

/*
* Function: _Z_NewBlock
* Purpose: Constructs a block descriptor without linking it into the zone list.
*/
function inline _Z_NewBlock(start, size, user, tag, id, next, prev)
  return memblock_t(start, size, user, tag, id, next, prev)
end function

/*
* Function: _Z_Align4
* Purpose: Rounds an allocation size upward to the allocator's four-byte boundary.
*/
function inline _Z_Align4(n)
  return (n + 3) &(~3)
end function

/*
* Function: _Z_LinkAfter
* Purpose: Inserts one block after another and updates all four neighboring list links atomically.
*/
function inline _Z_LinkAfter(aIdx, bIdx)

  a = _Z_Get(aIdx)
  b = _Z_Get(bIdx)
  nIdx = a.next

  b.prev = aIdx
  b.next = nIdx

  a.next = bIdx

  n = _Z_Get(nIdx)
  n.prev = bIdx

  _Z_Set(aIdx, a)
  _Z_Set(bIdx, b)
  _Z_Set(nIdx, n)
end function

/*
* Function: _Z_Unlink
* Purpose: Removes a block descriptor from the doubly linked address list and clears its own links.
*/
function inline _Z_Unlink(i)
  b = _Z_Get(i)
  pIdx = b.prev
  nIdx = b.next

  p = _Z_Get(pIdx)
  n = _Z_Get(nIdx)

  p.next = nIdx
  n.prev = pIdx

  _Z_Set(pIdx, p)
  _Z_Set(nIdx, n)

  b.next = 0
  b.prev = 0
  _Z_Set(i, b)
end function

/*
* Function: _Z_FindBlockByPtr
* Purpose: Finds the allocated block whose payload begins at a zone-buffer offset, returning the sentinel index when absent.
*/
function inline _Z_FindBlockByPtr(ptr)

  i = _Z_Get(_Z_blocklist).next
  while i != _Z_blocklist
    b = _Z_Get(i)
    if b.start + _Z_HDR == ptr then
      return i
    end if
    i = b.next
  end while
  return 0
end function

/*
* Function: _Z_AssignUser
* Purpose: Writes an allocated payload offset through Doom's single-element owner-reference convention.
*/
function inline _Z_AssignUser(user, ptr)

  if typeof(user) == "array" and len(user) > 0 then
    user[0] = ptr
  end if
end function

/*
* Function: Z_ClearZone
* Purpose: Replaces all allocator metadata with a sentinel and one free block covering the complete zone buffer.
*/
function Z_ClearZone(zone)
  global _Z_blocks
  global _Z_blocklist
  global _Z_rover
  zone = zone

  _Z_blocks =[void]

  _Z_blocklist = 1
  sentinel = _Z_NewBlock(0, 0, _Z_blocklist, PU_STATIC, ZONEID, 0, 0)
  _Z_blocks = _Z_blocks +[sentinel]

  freeIdx = 2
  freeBlock = _Z_NewBlock(0, _Z_size, void, 0, 0, _Z_blocklist, _Z_blocklist)
  _Z_blocks = _Z_blocks +[freeBlock]

  s = _Z_Get(_Z_blocklist)
  s.next = freeIdx
  s.prev = freeIdx
  _Z_Set(_Z_blocklist, s)

  _Z_rover = freeIdx
end function

/*
* Function: Z_Init
* Purpose: Obtains the platform zone buffer and initializes allocator metadata over its reported capacity.
*/
function Z_Init()
  global _Z_buf
  global _Z_size
  global _Z_blocks
  global _Z_blocklist
  global _Z_rover

  sizeOut =[0]
  _Z_buf = I_ZoneBase(sizeOut)
  _Z_size = sizeOut[0]
  Z_ClearZone(void)
end function

/*
* Function: Z_Free
* Purpose: Validates and releases an allocation, invalidates its owner reference, and coalesces adjacent free blocks while repairing the rover.
*/
function Z_Free(ptr)
  global _Z_rover

  idx = _Z_FindBlockByPtr(ptr)
  if idx == 0 then
    I_Error("Z_Free: invalid pointer (not a zone allocation)")
    return
  end if

  block = _Z_Get(idx)
  if block.id != ZONEID then
    I_Error("Z_Free: freed a pointer without ZONEID")
    return
  end if

  if typeof(block.user) == "array" and len(block.user) > 0 then

    block.user[0] = _Z_NULL_OWNER_PTR
  end if

  block.user = void
  block.tag = 0
  block.id = 0
  _Z_Set(idx, block)

  prevIdx = block.prev
  if prevIdx != 0 and prevIdx != _Z_blocklist and _Z_IsFree(prevIdx) then
    prevB = _Z_Get(prevIdx)
    prevB.size = prevB.size + block.size

    _Z_Unlink(idx)

    if _Z_rover == idx then _Z_rover = prevIdx end if

    _Z_Set(prevIdx, prevB)
    idx = prevIdx
    block = prevB
  end if

  nextIdx = block.next
  if nextIdx != 0 and nextIdx != _Z_blocklist and _Z_IsFree(nextIdx) then
    nextB = _Z_Get(nextIdx)
    block.size = block.size + nextB.size

    _Z_Unlink(nextIdx)

    if _Z_rover == nextIdx then _Z_rover = idx end if

    _Z_Set(idx, block)
  end if
end function

/*
* Function: Z_Malloc
* Purpose: Performs rover-based first-fit allocation, purges eligible tagged blocks, splits large remainders, and enforces owners for purgeable memory.
*/
function Z_Malloc(size, tag, user)
  global _Z_blocks
  global _Z_rover

  size = _Z_Align4(size)

  want = size + _Z_HDR

  base = _Z_rover
  b = _Z_Get(base)
  if b.prev != _Z_blocklist and _Z_IsFree(b.prev) then
    base = b.prev
  end if

  rover = base
  start = _Z_Get(base).prev

  loop
    if rover == start then
      I_Error("Z_Malloc: failed on allocation of " + want + " bytes")
      return void
    end if

    rb = _Z_Get(rover)

    if typeof(rb.user) != "void" then

      if rb.tag < PU_PURGELEVEL then
        base = rb.next
        rover = base
      else

        base = _Z_Get(base).prev
        Z_Free(rb.start + _Z_HDR)
        base = _Z_Get(base).next
        rover = _Z_Get(base).next
      end if
    else
      rover = rb.next
    end if

    bb = _Z_Get(base)
    if typeof(bb.user) == "void" and bb.size >= want then
      break
    end if
    while true
    end loop

    baseB = _Z_Get(base)
    extra = baseB.size - want

    if extra > MINFRAGMENT then

      newStart = baseB.start + want
      newIdx = len(_Z_blocks)
      newBlock = _Z_NewBlock(newStart, extra, void, 0, 0, 0, 0)

      _Z_blocks = _Z_blocks +[newBlock]

      _Z_LinkAfter(base, newIdx)

      baseB.size = want
    end if

    if typeof(user) != "void" then
      baseB.user = user
      _Z_AssignUser(user, baseB.start + _Z_HDR)
    else
      if tag >= PU_PURGELEVEL then
        I_Error("Z_Malloc: an owner is required for purgable blocks")
      end if
      baseB.user = 2
    end if

    baseB.tag = tag
    baseB.id = ZONEID
    _Z_Set(base, baseB)

    _Z_rover = baseB.next

    return baseB.start + _Z_HDR
  end function

  /*
* Function: Z_FreeTags
* Purpose: Frees every allocated block whose purge tag lies in the inclusive requested range while preserving traversal across coalescing.
  */
  function Z_FreeTags(lowtag, hightag)
    head = _Z_Get(_Z_blocklist)
    if head is void then return end if

    i = head.next
    guard = 0
    while i != _Z_blocklist and guard < 1048576
      if typeof(i) != "int" or i <= 0 then break end if
      b = _Z_Get(i)
      if b is void then break end if
      nextI = b.next
      if typeof(nextI) != "int" then nextI = _Z_blocklist end if

      if typeof(b.user) != "void" then
        if b.tag >= lowtag and b.tag <= hightag then
          Z_Free(b.start + _Z_HDR)
        end if
      end if

      i = nextI
      guard = guard + 1
    end while
  end function

  /*
* Function: Z_DumpHeap
* Purpose: Prints allocator size and metadata for blocks in a selected tag range for diagnostics.
  */
  function Z_DumpHeap(lowtag, hightag)
    print "zone size: " + _Z_size
    print "tag range: " + lowtag + " to " + hightag

    i = _Z_Get(_Z_blocklist).next
    while i != _Z_blocklist
      b = _Z_Get(i)
      if b.tag >= lowtag and b.tag <= hightag then
        print "block idx=" + i + " start=" + b.start + " size=" + b.size + " user=" + b.user + " tag=" + b.tag
      end if
      i = b.next
    end while
  end function

  /*
* Function: Z_FileDumpHeap
* Purpose: Preserves the legacy file-dump entry point by emitting the complete heap through the active diagnostic output.
  */
  function Z_FileDumpHeap(f)

    Z_DumpHeap(0, 9999)
  end function

  /*
* Function: Z_CheckHeap
* Purpose: Verifies bidirectional links, contiguous address coverage, absence of adjacent free blocks, and the final zone extent.
  */
  function Z_CheckHeap()

    i = _Z_Get(_Z_blocklist).next
    lastWasFree = false
    lastEnd = 0

    while i != _Z_blocklist
      b = _Z_Get(i)

      if b.prev == 0 or b.next == 0 then
        I_Error("Z_CheckHeap: broken links")
        return
      end if

      if b.start != lastEnd then

        I_Error("Z_CheckHeap: block layout not contiguous")
        return
      end if

      isFree =(typeof(b.user) == "void")
      if isFree and lastWasFree then
        I_Error("Z_CheckHeap: two consecutive free blocks")
        return
      end if

      lastWasFree = isFree
      lastEnd = b.start + b.size
      i = b.next
    end while

    if lastEnd != _Z_size then
      I_Error("Z_CheckHeap: heap end mismatch")
    end if
  end function

  /*
* Function: Z_ChangeTag2
* Purpose: Retags a validated allocation while forbidding purgeable tags on blocks without an owner reference.
  */
  function Z_ChangeTag2(ptr, tag)
    idx = _Z_FindBlockByPtr(ptr)
    if idx == 0 then
      I_Error("Z_ChangeTag: invalid pointer")
      return
    end if

    b = _Z_Get(idx)
    if b.id != ZONEID then
      I_Error("Z_ChangeTag: freed a pointer without ZONEID")
      return
    end if

    if tag >= PU_PURGELEVEL and(typeof(b.user) != "array") and(b.user == 2) then

      I_Error("Z_ChangeTag: an owner is required for purgable blocks")
      return
    end if

    b.tag = tag
    _Z_Set(idx, b)
  end function

  /*
* Function: Z_ChangeTag
* Purpose: Exposes the validated retagging operation under the original zone API name.
  */
  function Z_ChangeTag(ptr, tag)
    Z_ChangeTag2(ptr, tag)
  end function

  /*
* Function: Z_FreeMemory
* Purpose: Totals immediately free and purgeable bytes to estimate memory available for a future allocation.
  */
  function Z_FreeMemory()
    free = 0
    i = _Z_Get(_Z_blocklist).next
    while i != _Z_blocklist
      b = _Z_Get(i)
      if typeof(b.user) == "void" or b.tag >= PU_PURGELEVEL then
        free = free + b.size
      end if
      i = b.next
    end while
    return free
  end function

  /*
* Function: Z_GetZoneBuffer
* Purpose: Returns the backing byte buffer addressed by all zone payload offsets.
  */
  function Z_GetZoneBuffer()
    return _Z_buf
  end function

  /*
* Function: Z_PeekByte
* Purpose: Reads one byte at an absolute zone-buffer offset.
  */
  function Z_PeekByte(ptr)
    return _Z_buf[ptr]
  end function

  /*
* Function: Z_PokeByte
* Purpose: Writes the low eight bits of a value at an absolute zone-buffer offset.
  */
  function Z_PokeByte(ptr, v)
    _Z_buf[ptr] = v & 255
  end function

  /*
* Function: Z_PokeBytes
* Purpose: Copies a validated source byte range into the zone buffer at an absolute payload offset.
  */
  function Z_PokeBytes(dstPtr, srcBytes, srcOff, length)
    if typeof(dstPtr) != "int" then
      I_Error("Z_PokeBytes: dstPtr must be int offset")
      return
    end if
    if typeof(srcBytes) != "bytes" then
      I_Error("Z_PokeBytes: srcBytes must be bytes")
      return
    end if
    if srcOff < 0 or length < 0 then
      I_Error("Z_PokeBytes: invalid srcOff/length")
      return
    end if
    for i = 0 to length - 1
      _Z_buf[dstPtr + i] = srcBytes[srcOff + i]
    end for
  end function

  /*
* Function: Z_BytesAt
* Purpose: Returns a byte slice copied from an absolute zone-buffer range.
  */
  function Z_BytesAt(ptr, length)
    return slice(_Z_buf, ptr, length)
  end function



