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

*/

//! Defines callback wrappers and linked-list nodes used by Doom's per-tic thinker scheduler.


/// Wraps the optional single-argument callback invoked for an active thinker node.
struct actionf_t
  /// Stores acp1 for `actionf_t`
  acp1
  /// Stores acv for `actionf_t`
  acv
  /// Stores acp2 for `actionf_t`
  acp2
end struct

/// Forms one node of the doubly linked thinker list and associates it with a callback and optional owning
/// object.
struct thinker_t
  /// Previous linked record in traversal order stored by `thinker_t`
  prev
  /// Next linked record in traversal order stored by `thinker_t`
  next
  /// Stores func for `thinker_t`
  func
  /// Stores owner for `thinker_t`
  owner
end struct



