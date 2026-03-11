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

  Script: doomdef.ml
  Purpose: Contains Doom engine module logic for this subsystem.
*/

const VERSION = 110

/*
* Enum: GameMode_t
* Purpose: Defines named constants for Game Mode type.
*/
enum GameMode_t
  shareware
  registered
  commercial
  retail
  indetermined
end enum

/*
* Enum: GameMission_t
* Purpose: Defines named constants for Game Mission type.
*/
enum GameMission_t
  doom
  doom2
  pack_tnt
  pack_plut
  none
end enum

/*
* Enum: Language_t
* Purpose: Defines named constants for Language type.
*/
enum Language_t
  english
  french
  german
  unknown
end enum

const RANGECHECK = true

const SNDSERV = 1

const BASE_WIDTH = 320
const SCREEN_MUL = 1
const INV_ASPECT_RATIO = 0.625

const SCREENWIDTH = 320
const SCREENHEIGHT = 200

const MAXPLAYERS = 4

const TICRATE = 35

/*
* Enum: gamestate_t
* Purpose: Defines named constants for gamestate type.
*/
enum gamestate_t
  GS_LEVEL
  GS_INTERMISSION
  GS_FINALE
  GS_DEMOSCREEN
end enum

const MTF_EASY = 1
const MTF_NORMAL = 2
const MTF_HARD = 4
const MTF_AMBUSH = 8

/*
* Enum: skill_t
* Purpose: Defines named constants for skill type.
*/
enum skill_t
  sk_baby
  sk_easy
  sk_medium
  sk_hard
  sk_nightmare
end enum

/*
* Enum: card_t
* Purpose: Defines named constants for card type.
*/
enum card_t
  it_bluecard
  it_yellowcard
  it_redcard
  it_blueskull
  it_yellowskull
  it_redskull

  NUMCARDS
end enum

/*
* Enum: weapontype_t
* Purpose: Defines named constants for weapontype type.
*/
enum weapontype_t
  wp_fist
  wp_pistol
  wp_shotgun
  wp_chaingun
  wp_missile
  wp_plasma
  wp_bfg
  wp_chainsaw
  wp_supershotgun

  NUMWEAPONS
  wp_nochange
end enum

/*
* Enum: ammotype_t
* Purpose: Defines named constants for ammotype type.
*/
enum ammotype_t
  am_clip
  am_shell
  am_cell
  am_misl

  NUMAMMO
  am_noammo
end enum

/*
* Enum: powertype_t
* Purpose: Defines named constants for powertype type.
*/
enum powertype_t
  pw_invulnerability
  pw_strength
  pw_invisibility
  pw_ironfeet
  pw_allmap
  pw_infrared

  NUMPOWERS
end enum

/*
* Enum: powerduration_t
* Purpose: Defines named constants for powerduration type.
*/
enum powerduration_t
  INVULNTICS = 30 * TICRATE
  INVISTICS = 60 * TICRATE
  INFRATICS = 120 * TICRATE
  IRONTICS = 60 * TICRATE
end enum

shareware = GameMode_t.shareware
registered = GameMode_t.registered
commercial = GameMode_t.commercial
retail = GameMode_t.retail
indetermined = GameMode_t.indetermined

GS_LEVEL = gamestate_t.GS_LEVEL
GS_INTERMISSION = gamestate_t.GS_INTERMISSION
GS_FINALE = gamestate_t.GS_FINALE
GS_DEMOSCREEN = gamestate_t.GS_DEMOSCREEN

sk_baby = skill_t.sk_baby
sk_easy = skill_t.sk_easy
sk_medium = skill_t.sk_medium
sk_hard = skill_t.sk_hard
sk_nightmare = skill_t.sk_nightmare

it_bluecard = card_t.it_bluecard
it_yellowcard = card_t.it_yellowcard
it_redcard = card_t.it_redcard
it_blueskull = card_t.it_blueskull
it_yellowskull = card_t.it_yellowskull
it_redskull = card_t.it_redskull

NUMCARDS = 6

wp_fist = weapontype_t.wp_fist
wp_pistol = weapontype_t.wp_pistol
wp_shotgun = weapontype_t.wp_shotgun
wp_chaingun = weapontype_t.wp_chaingun
wp_missile = weapontype_t.wp_missile
wp_plasma = weapontype_t.wp_plasma
wp_bfg = weapontype_t.wp_bfg
wp_chainsaw = weapontype_t.wp_chainsaw
wp_supershotgun = weapontype_t.wp_supershotgun
NUMWEAPONS = 9
wp_nochange = weapontype_t.wp_nochange

am_clip = ammotype_t.am_clip
am_shell = ammotype_t.am_shell
am_cell = ammotype_t.am_cell
am_misl = ammotype_t.am_misl
NUMAMMO = 4
am_noammo = ammotype_t.am_noammo

pw_invulnerability = powertype_t.pw_invulnerability
pw_strength = powertype_t.pw_strength
pw_invisibility = powertype_t.pw_invisibility
pw_ironfeet = powertype_t.pw_ironfeet
pw_allmap = powertype_t.pw_allmap
pw_infrared = powertype_t.pw_infrared
NUMPOWERS = 6

INVULNTICS = 30 * TICRATE
INVISTICS = 60 * TICRATE
INFRATICS = 120 * TICRATE
IRONTICS = 60 * TICRATE

const KEY_RIGHTARROW = 0xae
const KEY_LEFTARROW = 0xac
const KEY_UPARROW = 0xad
const KEY_DOWNARROW = 0xaf

const KEY_ESCAPE = 27
const KEY_ENTER = 13
const KEY_TAB = 9

const KEY_F1 = 0x80 + 0x3b
const KEY_F2 = 0x80 + 0x3c
const KEY_F3 = 0x80 + 0x3d
const KEY_F4 = 0x80 + 0x3e
const KEY_F5 = 0x80 + 0x3f
const KEY_F6 = 0x80 + 0x40
const KEY_F7 = 0x80 + 0x41
const KEY_F8 = 0x80 + 0x42
const KEY_F9 = 0x80 + 0x43
const KEY_F10 = 0x80 + 0x44
const KEY_F11 = 0x80 + 0x57
const KEY_F12 = 0x80 + 0x58

const KEY_BACKSPACE = 127
const KEY_PAUSE = 0xff

const KEY_EQUALS = 0x3d
const KEY_MINUS = 0x2d

const KEY_RSHIFT = 0x80 + 0x36
const KEY_RCTRL = 0x80 + 0x1d
const KEY_RALT = 0x80 + 0x38

const KEY_LALT = KEY_RALT



