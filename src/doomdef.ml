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

//! Defines engine-wide version, game-mode, skill, state, input, and fixed-point constants shared across
//! subsystems.


/// Defines version for the doomdef subsystem.
const VERSION = 110

/// Classifies IWAD licensing/content layouts that control episode availability and map naming.
enum GameMode_t
  /// Represents shareware in `GameMode_t`
  shareware
  /// Represents registered in `GameMode_t`
  registered
  /// Represents commercial in `GameMode_t`
  commercial
  /// Represents retail in `GameMode_t`
  retail
  /// Represents indetermined in `GameMode_t`
  indetermined
end enum

/// Identifies the Doom, Doom II, TNT, or Plutonia mission whose rules and finale text are active.
enum GameMission_t
  /// Represents doom in `GameMission_t`
  doom
  /// Represents doom2 in `GameMission_t`
  doom2
  /// Represents pack tnt in `GameMission_t`
  pack_tnt
  /// Represents pack plut in `GameMission_t`
  pack_plut
  /// Represents none in `GameMission_t`
  none
end enum

/// Selects the localized string table used for messages, menus, and pickup text.
enum Language_t
  /// Represents english in `Language_t`
  english
  /// Represents french in `Language_t`
  french
  /// Represents german in `Language_t`
  german
  /// Represents unknown in `Language_t`
  unknown
end enum

/// Defines rangecheck for the doomdef subsystem.
const RANGECHECK = true

/// Defines sndserv for the doomdef subsystem.
const SNDSERV = 1

/// Defines base width for the doomdef subsystem.
const BASE_WIDTH = 320
/// Defines screen mul for the doomdef subsystem.
const SCREEN_MUL = 1
/// Defines inv aspect ratio for the doomdef subsystem.
const INV_ASPECT_RATIO = 0.625

/// Defines screenwidth for the doomdef subsystem.
const SCREENWIDTH = 320
/// Defines screenheight for the doomdef subsystem.
const SCREENHEIGHT = 200

/// Defines the maximum maxplayers accepted by the doomdef subsystem.
const MAXPLAYERS = 4

/// Defines ticrate for the doomdef subsystem.
const TICRATE = 35

/// Selects the top-level level, intermission, finale, or demo-screen ticker and renderer.
enum gamestate_t
  /// Represents gs level in `gamestate_t`
  GS_LEVEL
  /// Represents gs intermission in `gamestate_t`
  GS_INTERMISSION
  /// Represents gs finale in `gamestate_t`
  GS_FINALE
  /// Represents gs demoscreen in `gamestate_t`
  GS_DEMOSCREEN
end enum

/// Defines mtf easy for the doomdef subsystem.
const MTF_EASY = 1
/// Defines mtf normal for the doomdef subsystem.
const MTF_NORMAL = 2
/// Defines mtf hard for the doomdef subsystem.
const MTF_HARD = 4
/// Defines mtf ambush for the doomdef subsystem.
const MTF_AMBUSH = 8

/// Indexes the five gameplay difficulty tiers used for thing filtering and combat rule scaling.
enum skill_t
  /// Represents sk baby in `skill_t`
  sk_baby
  /// Represents sk easy in `skill_t`
  sk_easy
  /// Represents sk medium in `skill_t`
  sk_medium
  /// Represents sk hard in `skill_t`
  sk_hard
  /// Represents sk nightmare in `skill_t`
  sk_nightmare
end enum

/// Indexes the six key-card/skull inventory flags and exposes their array bound sentinel.
enum card_t
  /// Represents it bluecard in `card_t`
  it_bluecard
  /// Represents it yellowcard in `card_t`
  it_yellowcard
  /// Represents it redcard in `card_t`
  it_redcard
  /// Represents it blueskull in `card_t`
  it_blueskull
  /// Represents it yellowskull in `card_t`
  it_yellowskull
  /// Represents it redskull in `card_t`
  it_redskull

  /// Marks the number of values represented by `card_t`
  NUMCARDS
end enum

/// Indexes player weapon ownership/ammo metadata and includes count and no-change sentinels.
enum weapontype_t
  /// Represents wp fist in `weapontype_t`
  wp_fist
  /// Represents wp pistol in `weapontype_t`
  wp_pistol
  /// Represents wp shotgun in `weapontype_t`
  wp_shotgun
  /// Represents wp chaingun in `weapontype_t`
  wp_chaingun
  /// Represents wp missile in `weapontype_t`
  wp_missile
  /// Represents wp plasma in `weapontype_t`
  wp_plasma
  /// Represents wp bfg in `weapontype_t`
  wp_bfg
  /// Represents wp chainsaw in `weapontype_t`
  wp_chainsaw
  /// Represents wp supershotgun in `weapontype_t`
  wp_supershotgun

  /// Marks the number of values represented by `weapontype_t`
  NUMWEAPONS
  /// Represents wp nochange in `weapontype_t`
  wp_nochange
end enum

/// Indexes the four ammunition pools and includes count and weapon-without-ammo sentinels.
enum ammotype_t
  /// Represents am clip in `ammotype_t`
  am_clip
  /// Represents am shell in `ammotype_t`
  am_shell
  /// Represents am cell in `ammotype_t`
  am_cell
  /// Represents am misl in `ammotype_t`
  am_misl

  /// Marks the number of values represented by `ammotype_t`
  NUMAMMO
  /// Represents am noammo in `ammotype_t`
  am_noammo
end enum

/// Indexes timed and persistent power-up slots in each player's powers array.
enum powertype_t
  /// Represents pw invulnerability in `powertype_t`
  pw_invulnerability
  /// Represents pw strength in `powertype_t`
  pw_strength
  /// Represents pw invisibility in `powertype_t`
  pw_invisibility
  /// Represents pw ironfeet in `powertype_t`
  pw_ironfeet
  /// Represents pw allmap in `powertype_t`
  pw_allmap
  /// Represents pw infrared in `powertype_t`
  pw_infrared

  /// Marks the number of values represented by `powertype_t`
  NUMPOWERS
end enum

/// Defines canonical 35-Hz durations for invulnerability, invisibility, infrared, and radiation protection.
enum powerduration_t
  /// Represents invulntics in `powerduration_t`
  INVULNTICS = 30 * TICRATE
  /// Represents invistics in `powerduration_t`
  INVISTICS = 60 * TICRATE
  /// Represents infratics in `powerduration_t`
  INFRATICS = 120 * TICRATE
  /// Represents irontics in `powerduration_t`
  IRONTICS = 60 * TICRATE
end enum

/// Exposes `GameMode_t.shareware` through the legacy `shareware` alias.
shareware = GameMode_t.shareware
/// Exposes `GameMode_t.registered` through the legacy `registered` alias.
registered = GameMode_t.registered
/// Exposes `GameMode_t.commercial` through the legacy `commercial` alias.
commercial = GameMode_t.commercial
/// Exposes `GameMode_t.retail` through the legacy `retail` alias.
retail = GameMode_t.retail
/// Exposes `GameMode_t.indetermined` through the legacy `indetermined` alias.
indetermined = GameMode_t.indetermined

/// Exposes `gamestate_t.GS_LEVEL` through the legacy `GS_LEVEL` alias.
GS_LEVEL = gamestate_t.GS_LEVEL
/// Exposes `gamestate_t.GS_INTERMISSION` through the legacy `GS_INTERMISSION` alias.
GS_INTERMISSION = gamestate_t.GS_INTERMISSION
/// Exposes `gamestate_t.GS_FINALE` through the legacy `GS_FINALE` alias.
GS_FINALE = gamestate_t.GS_FINALE
/// Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `GS_DEMOSCREEN` alias.
GS_DEMOSCREEN = gamestate_t.GS_DEMOSCREEN

/// Exposes `skill_t.sk_baby` through the legacy `sk_baby` alias.
sk_baby = skill_t.sk_baby
/// Exposes `skill_t.sk_easy` through the legacy `sk_easy` alias.
sk_easy = skill_t.sk_easy
/// Exposes `skill_t.sk_medium` through the legacy `sk_medium` alias.
sk_medium = skill_t.sk_medium
/// Exposes `skill_t.sk_hard` through the legacy `sk_hard` alias.
sk_hard = skill_t.sk_hard
/// Exposes `skill_t.sk_nightmare` through the legacy `sk_nightmare` alias.
sk_nightmare = skill_t.sk_nightmare

/// Exposes `card_t.it_bluecard` through the legacy `it_bluecard` alias.
it_bluecard = card_t.it_bluecard
/// Exposes `card_t.it_yellowcard` through the legacy `it_yellowcard` alias.
it_yellowcard = card_t.it_yellowcard
/// Exposes `card_t.it_redcard` through the legacy `it_redcard` alias.
it_redcard = card_t.it_redcard
/// Exposes `card_t.it_blueskull` through the legacy `it_blueskull` alias.
it_blueskull = card_t.it_blueskull
/// Exposes `card_t.it_yellowskull` through the legacy `it_yellowskull` alias.
it_yellowskull = card_t.it_yellowskull
/// Exposes `card_t.it_redskull` through the legacy `it_redskull` alias.
it_redskull = card_t.it_redskull

/// Tracks the mutable numcards value used by the doomdef subsystem.
NUMCARDS = 6

/// Exposes `weapontype_t.wp_fist` through the legacy `wp_fist` alias.
wp_fist = weapontype_t.wp_fist
/// Exposes `weapontype_t.wp_pistol` through the legacy `wp_pistol` alias.
wp_pistol = weapontype_t.wp_pistol
/// Exposes `weapontype_t.wp_shotgun` through the legacy `wp_shotgun` alias.
wp_shotgun = weapontype_t.wp_shotgun
/// Exposes `weapontype_t.wp_chaingun` through the legacy `wp_chaingun` alias.
wp_chaingun = weapontype_t.wp_chaingun
/// Exposes `weapontype_t.wp_missile` through the legacy `wp_missile` alias.
wp_missile = weapontype_t.wp_missile
/// Exposes `weapontype_t.wp_plasma` through the legacy `wp_plasma` alias.
wp_plasma = weapontype_t.wp_plasma
/// Exposes `weapontype_t.wp_bfg` through the legacy `wp_bfg` alias.
wp_bfg = weapontype_t.wp_bfg
/// Exposes `weapontype_t.wp_chainsaw` through the legacy `wp_chainsaw` alias.
wp_chainsaw = weapontype_t.wp_chainsaw
/// Exposes `weapontype_t.wp_supershotgun` through the legacy `wp_supershotgun` alias.
wp_supershotgun = weapontype_t.wp_supershotgun
/// Tracks the mutable numweapons value used by the doomdef subsystem.
NUMWEAPONS = 9
/// Exposes `weapontype_t.wp_nochange` through the legacy `wp_nochange` alias.
wp_nochange = weapontype_t.wp_nochange

/// Exposes `ammotype_t.am_clip` through the legacy `am_clip` alias.
am_clip = ammotype_t.am_clip
/// Exposes `ammotype_t.am_shell` through the legacy `am_shell` alias.
am_shell = ammotype_t.am_shell
/// Exposes `ammotype_t.am_cell` through the legacy `am_cell` alias.
am_cell = ammotype_t.am_cell
/// Exposes `ammotype_t.am_misl` through the legacy `am_misl` alias.
am_misl = ammotype_t.am_misl
/// Tracks the mutable numammo value used by the doomdef subsystem.
NUMAMMO = 4
/// Exposes `ammotype_t.am_noammo` through the legacy `am_noammo` alias.
am_noammo = ammotype_t.am_noammo

/// Exposes `powertype_t.pw_invulnerability` through the legacy `pw_invulnerability` alias.
pw_invulnerability = powertype_t.pw_invulnerability
/// Exposes `powertype_t.pw_strength` through the legacy `pw_strength` alias.
pw_strength = powertype_t.pw_strength
/// Exposes `powertype_t.pw_invisibility` through the legacy `pw_invisibility` alias.
pw_invisibility = powertype_t.pw_invisibility
/// Exposes `powertype_t.pw_ironfeet` through the legacy `pw_ironfeet` alias.
pw_ironfeet = powertype_t.pw_ironfeet
/// Exposes `powertype_t.pw_allmap` through the legacy `pw_allmap` alias.
pw_allmap = powertype_t.pw_allmap
/// Exposes `powertype_t.pw_infrared` through the legacy `pw_infrared` alias.
pw_infrared = powertype_t.pw_infrared
/// Tracks the mutable numpowers value used by the doomdef subsystem.
NUMPOWERS = 6

/// Tracks the mutable invulntics value used by the doomdef subsystem.
INVULNTICS = 30 * TICRATE
/// Tracks the mutable invistics value used by the doomdef subsystem.
INVISTICS = 60 * TICRATE
/// Tracks the mutable infratics value used by the doomdef subsystem.
INFRATICS = 120 * TICRATE
/// Tracks the mutable irontics value used by the doomdef subsystem.
IRONTICS = 60 * TICRATE

/// Defines the input key code for key rightarrow.
const KEY_RIGHTARROW = 0xae
/// Defines the input key code for key leftarrow.
const KEY_LEFTARROW = 0xac
/// Defines the input key code for key uparrow.
const KEY_UPARROW = 0xad
/// Defines the input key code for key downarrow.
const KEY_DOWNARROW = 0xaf

/// Defines the input key code for key escape.
const KEY_ESCAPE = 27
/// Defines the input key code for key enter.
const KEY_ENTER = 13
/// Defines the input key code for key tab.
const KEY_TAB = 9

/// Defines the input key code for key f1.
const KEY_F1 = 0x80 + 0x3b
/// Defines the input key code for key f2.
const KEY_F2 = 0x80 + 0x3c
/// Defines the input key code for key f3.
const KEY_F3 = 0x80 + 0x3d
/// Defines the input key code for key f4.
const KEY_F4 = 0x80 + 0x3e
/// Defines the input key code for key f5.
const KEY_F5 = 0x80 + 0x3f
/// Defines the input key code for key f6.
const KEY_F6 = 0x80 + 0x40
/// Defines the input key code for key f7.
const KEY_F7 = 0x80 + 0x41
/// Defines the input key code for key f8.
const KEY_F8 = 0x80 + 0x42
/// Defines the input key code for key f9.
const KEY_F9 = 0x80 + 0x43
/// Defines the input key code for key f10.
const KEY_F10 = 0x80 + 0x44
/// Defines the input key code for key f11.
const KEY_F11 = 0x80 + 0x57
/// Defines the input key code for key f12.
const KEY_F12 = 0x80 + 0x58

/// Defines the input key code for key backspace.
const KEY_BACKSPACE = 127
/// Defines the input key code for key pause.
const KEY_PAUSE = 0xff

// Private UI key codes live above the legacy 8-bit gameplay-key table.
/// Defines the input key code for key console.
const KEY_CONSOLE = 0x100
/// Defines the input key code for key pageup.
const KEY_PAGEUP = 0x101
/// Defines the input key code for key pagedown.
const KEY_PAGEDOWN = 0x102

/// Defines the input key code for key equals.
const KEY_EQUALS = 0x3d
/// Defines the minimum key minus accepted by the doomdef subsystem.
const KEY_MINUS = 0x2d

/// Defines the input key code for key rshift.
const KEY_RSHIFT = 0x80 + 0x36
/// Defines the input key code for key rctrl.
const KEY_RCTRL = 0x80 + 0x1d
/// Defines the input key code for key ralt.
const KEY_RALT = 0x80 + 0x38

/// Defines the input key code for key lalt.
const KEY_LALT = KEY_RALT



