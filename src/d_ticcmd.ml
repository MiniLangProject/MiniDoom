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

  Script: d_ticcmd.ml
  Purpose: Defines the deterministic per-tic input command shared by local and network game loops.
*/
import doomtype

/*
* Struct: ticcmd_t
* Purpose: Stores movement, view, consistency, chat, and button state for exactly one simulation tic.
* Invariant: All six fields are serialized as signed 32-bit values by i_net and must remain in this wire order.
*/
struct ticcmd_t
  forwardmove   // Signed forward/back movement impulse.
  sidemove      // Signed strafe movement impulse.
  angleturn     // Signed view-angle delta.
  consistancy   // Determinism check value for the originating tic.
  chatchar      // One queued chat character, or zero.
  buttons       // Bit field of attack/use/weapon actions.
end struct



