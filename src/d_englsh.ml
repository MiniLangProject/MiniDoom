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

//! Supplies the original English menu, status, pickup, key, and level-title strings used by the Doom UI.


/// Defines the d devstr text used by the d englsh subsystem.
const D_DEVSTR = "Development mode ON.\n"
/// Defines the d cdrom text used by the d englsh subsystem.
const D_CDROM = "CD-ROM Version: default.cfg from c:\\doomdata\n"
/// Defines the input key code for presskey.
const PRESSKEY = "press a key."
/// Defines the pressyn text used by the d englsh subsystem.
const PRESSYN = "press y or n."
/// Defines the quitmsg text used by the d englsh subsystem.
const QUITMSG = "are you sure you want to\nquit this great game?"
/// Defines the loadnet text used by the d englsh subsystem.
const LOADNET = "you can't do load while in a net game!\n\npress a key."
/// Defines the qloadnet text used by the d englsh subsystem.
const QLOADNET = "you can't quickload during a netgame!\n\npress a key."
/// Defines the qsavespot text used by the d englsh subsystem.
const QSAVESPOT = "you haven't picked a quicksave slot yet!\n\npress a key."
/// Defines the savedead text used by the d englsh subsystem.
const SAVEDEAD = "you can't save if you aren't playing!\n\npress a key."
/// Defines the qsprompt text used by the d englsh subsystem.
const QSPROMPT = "quicksave over your game named\n\n'%s'?\n\npress y or n."
/// Defines the qlprompt text used by the d englsh subsystem.
const QLPROMPT = "do you want to quickload the game named\n\n'%s'?\n\npress y or n."
/// Defines the newgame text used by the d englsh subsystem.
const NEWGAME = "you can't start a new game\nwhile in a network game.\n\npress a key."
/// Defines the nightmare text used by the d englsh subsystem.
const NIGHTMARE = "are you sure? this skill level\nisn't even remotely fair.\n\npress y or n."
/// Defines the swstring text used by the d englsh subsystem.
const SWSTRING = "this is the shareware version of doom.\n\nyou need to order the entire trilogy.\n\npress a key."
/// Defines the msgoff text used by the d englsh subsystem.
const MSGOFF = "Messages OFF"
/// Defines the msgon text used by the d englsh subsystem.
const MSGON = "Messages ON"
/// Defines the netend text used by the d englsh subsystem.
const NETEND = "you can't end a netgame!\n\npress a key."
/// Defines the endgame text used by the d englsh subsystem.
const ENDGAME = "are you sure you want to end the game?\n\npress y or n."
/// Defines the dosy text used by the d englsh subsystem.
const DOSY = "(press y to quit)"
/// Defines the detailhi text used by the d englsh subsystem.
const DETAILHI = "High detail"
/// Defines the detaillo text used by the d englsh subsystem.
const DETAILLO = "Low detail"
/// Defines the gammalvl0 text used by the d englsh subsystem.
const GAMMALVL0 = "Gamma correction OFF"
/// Defines the gammalvl1 text used by the d englsh subsystem.
const GAMMALVL1 = "Gamma correction level 1"
/// Defines the gammalvl2 text used by the d englsh subsystem.
const GAMMALVL2 = "Gamma correction level 2"
/// Defines the gammalvl3 text used by the d englsh subsystem.
const GAMMALVL3 = "Gamma correction level 3"
/// Defines the gammalvl4 text used by the d englsh subsystem.
const GAMMALVL4 = "Gamma correction level 4"
/// Defines the emptystring text used by the d englsh subsystem.
const EMPTYSTRING = "empty slot"
/// Defines the gotarmor text used by the d englsh subsystem.
const GOTARMOR = "Picked up the armor."
/// Defines the gotmega text used by the d englsh subsystem.
const GOTMEGA = "Picked up the MegaArmor!"
/// Defines the goththbonus text used by the d englsh subsystem.
const GOTHTHBONUS = "Picked up a health bonus."
/// Defines the gotarmbonus text used by the d englsh subsystem.
const GOTARMBONUS = "Picked up an armor bonus."
/// Defines the gotstim text used by the d englsh subsystem.
const GOTSTIM = "Picked up a stimpack."
/// Defines the gotmedineed text used by the d englsh subsystem.
const GOTMEDINEED = "Picked up a medikit that you REALLY need!"
/// Defines the gotmedikit text used by the d englsh subsystem.
const GOTMEDIKIT = "Picked up a medikit."
/// Defines the gotsuper text used by the d englsh subsystem.
const GOTSUPER = "Supercharge!"
/// Defines the gotbluecard text used by the d englsh subsystem.
const GOTBLUECARD = "Picked up a blue keycard."
/// Defines the gotyelwcard text used by the d englsh subsystem.
const GOTYELWCARD = "Picked up a yellow keycard."
/// Defines the gotredcard text used by the d englsh subsystem.
const GOTREDCARD = "Picked up a red keycard."
/// Defines the gotblueskul text used by the d englsh subsystem.
const GOTBLUESKUL = "Picked up a blue skull key."
/// Defines the gotyelwskul text used by the d englsh subsystem.
const GOTYELWSKUL = "Picked up a yellow skull key."
/// Defines the gotredskull text used by the d englsh subsystem.
const GOTREDSKULL = "Picked up a red skull key."
/// Defines the gotinvul text used by the d englsh subsystem.
const GOTINVUL = "Invulnerability!"
/// Defines the gotberserk text used by the d englsh subsystem.
const GOTBERSERK = "Berserk!"
/// Defines the gotinvis text used by the d englsh subsystem.
const GOTINVIS = "Partial Invisibility"
/// Defines the gotsuit text used by the d englsh subsystem.
const GOTSUIT = "Radiation Shielding Suit"
/// Defines the gotmap text used by the d englsh subsystem.
const GOTMAP = "Computer Area Map"
/// Defines the gotvisor text used by the d englsh subsystem.
const GOTVISOR = "Light Amplification Visor"
/// Defines the gotmsphere text used by the d englsh subsystem.
const GOTMSPHERE = "MegaSphere!"
/// Defines the gotclip text used by the d englsh subsystem.
const GOTCLIP = "Picked up a clip."
/// Defines the gotclipbox text used by the d englsh subsystem.
const GOTCLIPBOX = "Picked up a box of bullets."
/// Defines the gotrocket text used by the d englsh subsystem.
const GOTROCKET = "Picked up a rocket."
/// Defines the gotrockbox text used by the d englsh subsystem.
const GOTROCKBOX = "Picked up a box of rockets."
/// Defines the gotcell text used by the d englsh subsystem.
const GOTCELL = "Picked up an energy cell."
/// Defines the gotcellbox text used by the d englsh subsystem.
const GOTCELLBOX = "Picked up an energy cell pack."
/// Defines the gotshells text used by the d englsh subsystem.
const GOTSHELLS = "Picked up 4 shotgun shells."
/// Defines the gotshellbox text used by the d englsh subsystem.
const GOTSHELLBOX = "Picked up a box of shotgun shells."
/// Defines the gotbackpack text used by the d englsh subsystem.
const GOTBACKPACK = "Picked up a backpack full of ammo!"
/// Defines the gotbfg9000 text used by the d englsh subsystem.
const GOTBFG9000 = "You got the BFG9000!  Oh, yes."
/// Defines the gotchaingun text used by the d englsh subsystem.
const GOTCHAINGUN = "You got the chaingun!"
/// Defines the gotchainsaw text used by the d englsh subsystem.
const GOTCHAINSAW = "A chainsaw!  Find some meat!"
/// Defines the gotlauncher text used by the d englsh subsystem.
const GOTLAUNCHER = "You got the rocket launcher!"
/// Defines the gotplasma text used by the d englsh subsystem.
const GOTPLASMA = "You got the plasma gun!"
/// Defines the gotshotgun text used by the d englsh subsystem.
const GOTSHOTGUN = "You got the shotgun!"
/// Defines the gotshotgun2 text used by the d englsh subsystem.
const GOTSHOTGUN2 = "You got the super shotgun!"
/// Defines the pd blueo text used by the d englsh subsystem.
const PD_BLUEO = "You need a blue key to activate this object"
/// Defines the pd redo text used by the d englsh subsystem.
const PD_REDO = "You need a red key to activate this object"
/// Defines the pd yellowo text used by the d englsh subsystem.
const PD_YELLOWO = "You need a yellow key to activate this object"
/// Defines the pd bluek text used by the d englsh subsystem.
const PD_BLUEK = "You need a blue key to open this door"
/// Defines the pd redk text used by the d englsh subsystem.
const PD_REDK = "You need a red key to open this door"
/// Defines the pd yellowk text used by the d englsh subsystem.
const PD_YELLOWK = "You need a yellow key to open this door"
/// Defines the ggsaved text used by the d englsh subsystem.
const GGSAVED = "game saved."
/// Defines the hustr msgu text used by the d englsh subsystem.
const HUSTR_MSGU = "[Message unsent]"
/// Defines the hustr e1 m1 text used by the d englsh subsystem.
const HUSTR_E1M1 = "E1M1: Hangar"
/// Defines the hustr e1 m2 text used by the d englsh subsystem.
const HUSTR_E1M2 = "E1M2: Nuclear Plant"
/// Defines the hustr e1 m3 text used by the d englsh subsystem.
const HUSTR_E1M3 = "E1M3: Toxin Refinery"
/// Defines the hustr e1 m4 text used by the d englsh subsystem.
const HUSTR_E1M4 = "E1M4: Command Control"
/// Defines the hustr e1 m5 text used by the d englsh subsystem.
const HUSTR_E1M5 = "E1M5: Phobos Lab"
/// Defines the hustr e1 m6 text used by the d englsh subsystem.
const HUSTR_E1M6 = "E1M6: Central Processing"
/// Defines the hustr e1 m7 text used by the d englsh subsystem.
const HUSTR_E1M7 = "E1M7: Computer Station"
/// Defines the hustr e1 m8 text used by the d englsh subsystem.
const HUSTR_E1M8 = "E1M8: Phobos Anomaly"
/// Defines the hustr e1 m9 text used by the d englsh subsystem.
const HUSTR_E1M9 = "E1M9: Military Base"
/// Defines the hustr e2 m1 text used by the d englsh subsystem.
const HUSTR_E2M1 = "E2M1: Deimos Anomaly"
/// Defines the hustr e2 m2 text used by the d englsh subsystem.
const HUSTR_E2M2 = "E2M2: Containment Area"
/// Defines the hustr e2 m3 text used by the d englsh subsystem.
const HUSTR_E2M3 = "E2M3: Refinery"
/// Defines the hustr e2 m4 text used by the d englsh subsystem.
const HUSTR_E2M4 = "E2M4: Deimos Lab"
/// Defines the hustr e2 m5 text used by the d englsh subsystem.
const HUSTR_E2M5 = "E2M5: Command Center"
/// Defines the hustr e2 m6 text used by the d englsh subsystem.
const HUSTR_E2M6 = "E2M6: Halls of the Damned"
/// Defines the hustr e2 m7 text used by the d englsh subsystem.
const HUSTR_E2M7 = "E2M7: Spawning Vats"
/// Defines the hustr e2 m8 text used by the d englsh subsystem.
const HUSTR_E2M8 = "E2M8: Tower of Babel"
/// Defines the hustr e2 m9 text used by the d englsh subsystem.
const HUSTR_E2M9 = "E2M9: Fortress of Mystery"
/// Defines the hustr e3 m1 text used by the d englsh subsystem.
const HUSTR_E3M1 = "E3M1: Hell Keep"
/// Defines the hustr e3 m2 text used by the d englsh subsystem.
const HUSTR_E3M2 = "E3M2: Slough of Despair"
/// Defines the hustr e3 m3 text used by the d englsh subsystem.
const HUSTR_E3M3 = "E3M3: Pandemonium"
/// Defines the hustr e3 m4 text used by the d englsh subsystem.
const HUSTR_E3M4 = "E3M4: House of Pain"
/// Defines the hustr e3 m5 text used by the d englsh subsystem.
const HUSTR_E3M5 = "E3M5: Unholy Cathedral"
/// Defines the hustr e3 m6 text used by the d englsh subsystem.
const HUSTR_E3M6 = "E3M6: Mt. Erebus"
/// Defines the hustr e3 m7 text used by the d englsh subsystem.
const HUSTR_E3M7 = "E3M7: Limbo"
/// Defines the hustr e3 m8 text used by the d englsh subsystem.
const HUSTR_E3M8 = "E3M8: Dis"
/// Defines the hustr e3 m9 text used by the d englsh subsystem.
const HUSTR_E3M9 = "E3M9: Warrens"
/// Defines the hustr e4 m1 text used by the d englsh subsystem.
const HUSTR_E4M1 = "E4M1: Hell Beneath"
/// Defines the hustr e4 m2 text used by the d englsh subsystem.
const HUSTR_E4M2 = "E4M2: Perfect Hatred"
/// Defines the hustr e4 m3 text used by the d englsh subsystem.
const HUSTR_E4M3 = "E4M3: Sever The Wicked"
/// Defines the hustr e4 m4 text used by the d englsh subsystem.
const HUSTR_E4M4 = "E4M4: Unruly Evil"
/// Defines the hustr e4 m5 text used by the d englsh subsystem.
const HUSTR_E4M5 = "E4M5: They Will Repent"
/// Defines the hustr e4 m6 text used by the d englsh subsystem.
const HUSTR_E4M6 = "E4M6: Against Thee Wickedly"
/// Defines the hustr e4 m7 text used by the d englsh subsystem.
const HUSTR_E4M7 = "E4M7: And Hell Followed"
/// Defines the hustr e4 m8 text used by the d englsh subsystem.
const HUSTR_E4M8 = "E4M8: Unto The Cruel"
/// Defines the hustr e4 m9 text used by the d englsh subsystem.
const HUSTR_E4M9 = "E4M9: Fear"
/// Defines the hustr 1 text used by the d englsh subsystem.
const HUSTR_1 = "level 1: entryway"
/// Defines the hustr 2 text used by the d englsh subsystem.
const HUSTR_2 = "level 2: underhalls"
/// Defines the hustr 3 text used by the d englsh subsystem.
const HUSTR_3 = "level 3: the gantlet"
/// Defines the hustr 4 text used by the d englsh subsystem.
const HUSTR_4 = "level 4: the focus"
/// Defines the hustr 5 text used by the d englsh subsystem.
const HUSTR_5 = "level 5: the waste tunnels"
/// Defines the hustr 6 text used by the d englsh subsystem.
const HUSTR_6 = "level 6: the crusher"
/// Defines the hustr 7 text used by the d englsh subsystem.
const HUSTR_7 = "level 7: dead simple"
/// Defines the hustr 8 text used by the d englsh subsystem.
const HUSTR_8 = "level 8: tricks and traps"
/// Defines the hustr 9 text used by the d englsh subsystem.
const HUSTR_9 = "level 9: the pit"
/// Defines the hustr 10 text used by the d englsh subsystem.
const HUSTR_10 = "level 10: refueling base"
/// Defines the hustr 11 text used by the d englsh subsystem.
const HUSTR_11 = "level 11: 'o' of destruction!"
/// Defines the hustr 12 text used by the d englsh subsystem.
const HUSTR_12 = "level 12: the factory"
/// Defines the hustr 13 text used by the d englsh subsystem.
const HUSTR_13 = "level 13: downtown"
/// Defines the hustr 14 text used by the d englsh subsystem.
const HUSTR_14 = "level 14: the inmost dens"
/// Defines the hustr 15 text used by the d englsh subsystem.
const HUSTR_15 = "level 15: industrial zone"
/// Defines the hustr 16 text used by the d englsh subsystem.
const HUSTR_16 = "level 16: suburbs"
/// Defines the hustr 17 text used by the d englsh subsystem.
const HUSTR_17 = "level 17: tenements"
/// Defines the hustr 18 text used by the d englsh subsystem.
const HUSTR_18 = "level 18: the courtyard"
/// Defines the hustr 19 text used by the d englsh subsystem.
const HUSTR_19 = "level 19: the citadel"
/// Defines the hustr 20 text used by the d englsh subsystem.
const HUSTR_20 = "level 20: gotcha!"
/// Defines the hustr 21 text used by the d englsh subsystem.
const HUSTR_21 = "level 21: nirvana"
/// Defines the hustr 22 text used by the d englsh subsystem.
const HUSTR_22 = "level 22: the catacombs"
/// Defines the hustr 23 text used by the d englsh subsystem.
const HUSTR_23 = "level 23: barrels o' fun"
/// Defines the hustr 24 text used by the d englsh subsystem.
const HUSTR_24 = "level 24: the chasm"
/// Defines the hustr 25 text used by the d englsh subsystem.
const HUSTR_25 = "level 25: bloodfalls"
/// Defines the hustr 26 text used by the d englsh subsystem.
const HUSTR_26 = "level 26: the abandoned mines"
/// Defines the hustr 27 text used by the d englsh subsystem.
const HUSTR_27 = "level 27: monster condo"
/// Defines the hustr 28 text used by the d englsh subsystem.
const HUSTR_28 = "level 28: the spirit world"
/// Defines the hustr 29 text used by the d englsh subsystem.
const HUSTR_29 = "level 29: the living end"
/// Defines the hustr 30 text used by the d englsh subsystem.
const HUSTR_30 = "level 30: icon of sin"
/// Defines the hustr 31 text used by the d englsh subsystem.
const HUSTR_31 = "level 31: wolfenstein"
/// Defines the hustr 32 text used by the d englsh subsystem.
const HUSTR_32 = "level 32: grosse"
/// Defines the phustr 1 text used by the d englsh subsystem.
const PHUSTR_1 = "level 1: congo"
/// Defines the phustr 2 text used by the d englsh subsystem.
const PHUSTR_2 = "level 2: well of souls"
/// Defines the phustr 3 text used by the d englsh subsystem.
const PHUSTR_3 = "level 3: aztec"
/// Defines the phustr 4 text used by the d englsh subsystem.
const PHUSTR_4 = "level 4: caged"
/// Defines the phustr 5 text used by the d englsh subsystem.
const PHUSTR_5 = "level 5: ghost town"
/// Defines the phustr 6 text used by the d englsh subsystem.
const PHUSTR_6 = "level 6: baron's lair"
/// Defines the phustr 7 text used by the d englsh subsystem.
const PHUSTR_7 = "level 7: caughtyard"
/// Defines the phustr 8 text used by the d englsh subsystem.
const PHUSTR_8 = "level 8: realm"
/// Defines the phustr 9 text used by the d englsh subsystem.
const PHUSTR_9 = "level 9: abattoire"
/// Defines the phustr 10 text used by the d englsh subsystem.
const PHUSTR_10 = "level 10: onslaught"
/// Defines the phustr 11 text used by the d englsh subsystem.
const PHUSTR_11 = "level 11: hunted"
/// Defines the phustr 12 text used by the d englsh subsystem.
const PHUSTR_12 = "level 12: speed"
/// Defines the phustr 13 text used by the d englsh subsystem.
const PHUSTR_13 = "level 13: the crypt"
/// Defines the phustr 14 text used by the d englsh subsystem.
const PHUSTR_14 = "level 14: genesis"
/// Defines the phustr 15 text used by the d englsh subsystem.
const PHUSTR_15 = "level 15: the twilight"
/// Defines the phustr 16 text used by the d englsh subsystem.
const PHUSTR_16 = "level 16: the omen"
/// Defines the phustr 17 text used by the d englsh subsystem.
const PHUSTR_17 = "level 17: compound"
/// Defines the phustr 18 text used by the d englsh subsystem.
const PHUSTR_18 = "level 18: neurosphere"
/// Defines the phustr 19 text used by the d englsh subsystem.
const PHUSTR_19 = "level 19: nme"
/// Defines the phustr 20 text used by the d englsh subsystem.
const PHUSTR_20 = "level 20: the death domain"
/// Defines the phustr 21 text used by the d englsh subsystem.
const PHUSTR_21 = "level 21: slayer"
/// Defines the phustr 22 text used by the d englsh subsystem.
const PHUSTR_22 = "level 22: impossible mission"
/// Defines the phustr 23 text used by the d englsh subsystem.
const PHUSTR_23 = "level 23: tombstone"
/// Defines the phustr 24 text used by the d englsh subsystem.
const PHUSTR_24 = "level 24: the final frontier"
/// Defines the phustr 25 text used by the d englsh subsystem.
const PHUSTR_25 = "level 25: the temple of darkness"
/// Defines the phustr 26 text used by the d englsh subsystem.
const PHUSTR_26 = "level 26: bunker"
/// Defines the phustr 27 text used by the d englsh subsystem.
const PHUSTR_27 = "level 27: anti-christ"
/// Defines the phustr 28 text used by the d englsh subsystem.
const PHUSTR_28 = "level 28: the sewers"
/// Defines the phustr 29 text used by the d englsh subsystem.
const PHUSTR_29 = "level 29: odyssey of noises"
/// Defines the phustr 30 text used by the d englsh subsystem.
const PHUSTR_30 = "level 30: the gateway of hell"
/// Defines the phustr 31 text used by the d englsh subsystem.
const PHUSTR_31 = "level 31: cyberden"
/// Defines the phustr 32 text used by the d englsh subsystem.
const PHUSTR_32 = "level 32: go 2 it"
/// Defines the thustr 1 text used by the d englsh subsystem.
const THUSTR_1 = "level 1: system control"
/// Defines the thustr 2 text used by the d englsh subsystem.
const THUSTR_2 = "level 2: human bbq"
/// Defines the thustr 3 text used by the d englsh subsystem.
const THUSTR_3 = "level 3: power control"
/// Defines the thustr 4 text used by the d englsh subsystem.
const THUSTR_4 = "level 4: wormhole"
/// Defines the thustr 5 text used by the d englsh subsystem.
const THUSTR_5 = "level 5: hanger"
/// Defines the thustr 6 text used by the d englsh subsystem.
const THUSTR_6 = "level 6: open season"
/// Defines the thustr 7 text used by the d englsh subsystem.
const THUSTR_7 = "level 7: prison"
/// Defines the thustr 8 text used by the d englsh subsystem.
const THUSTR_8 = "level 8: metal"
/// Defines the thustr 9 text used by the d englsh subsystem.
const THUSTR_9 = "level 9: stronghold"
/// Defines the thustr 10 text used by the d englsh subsystem.
const THUSTR_10 = "level 10: redemption"
/// Defines the thustr 11 text used by the d englsh subsystem.
const THUSTR_11 = "level 11: storage facility"
/// Defines the thustr 12 text used by the d englsh subsystem.
const THUSTR_12 = "level 12: crater"
/// Defines the thustr 13 text used by the d englsh subsystem.
const THUSTR_13 = "level 13: nukage processing"
/// Defines the thustr 14 text used by the d englsh subsystem.
const THUSTR_14 = "level 14: steel works"
/// Defines the thustr 15 text used by the d englsh subsystem.
const THUSTR_15 = "level 15: dead zone"
/// Defines the thustr 16 text used by the d englsh subsystem.
const THUSTR_16 = "level 16: deepest reaches"
/// Defines the thustr 17 text used by the d englsh subsystem.
const THUSTR_17 = "level 17: processing area"
/// Defines the thustr 18 text used by the d englsh subsystem.
const THUSTR_18 = "level 18: mill"
/// Defines the thustr 19 text used by the d englsh subsystem.
const THUSTR_19 = "level 19: shipping/respawning"
/// Defines the thustr 20 text used by the d englsh subsystem.
const THUSTR_20 = "level 20: central processing"
/// Defines the thustr 21 text used by the d englsh subsystem.
const THUSTR_21 = "level 21: administration center"
/// Defines the thustr 22 text used by the d englsh subsystem.
const THUSTR_22 = "level 22: habitat"
/// Defines the thustr 23 text used by the d englsh subsystem.
const THUSTR_23 = "level 23: lunar mining project"
/// Defines the thustr 24 text used by the d englsh subsystem.
const THUSTR_24 = "level 24: quarry"
/// Defines the thustr 25 text used by the d englsh subsystem.
const THUSTR_25 = "level 25: baron's den"
/// Defines the thustr 26 text used by the d englsh subsystem.
const THUSTR_26 = "level 26: ballistyx"
/// Defines the thustr 27 text used by the d englsh subsystem.
const THUSTR_27 = "level 27: mount pain"
/// Defines the thustr 28 text used by the d englsh subsystem.
const THUSTR_28 = "level 28: heck"
/// Defines the thustr 29 text used by the d englsh subsystem.
const THUSTR_29 = "level 29: river styx"
/// Defines the thustr 30 text used by the d englsh subsystem.
const THUSTR_30 = "level 30: last call"
/// Defines the thustr 31 text used by the d englsh subsystem.
const THUSTR_31 = "level 31: pharaoh"
/// Defines the thustr 32 text used by the d englsh subsystem.
const THUSTR_32 = "level 32: caribbean"
/// Defines the hustr chatmacro1 text used by the d englsh subsystem.
const HUSTR_CHATMACRO1 = "I'm ready to kick butt!"
/// Defines the hustr chatmacro2 text used by the d englsh subsystem.
const HUSTR_CHATMACRO2 = "I'm OK."
/// Defines the hustr chatmacro3 text used by the d englsh subsystem.
const HUSTR_CHATMACRO3 = "I'm not looking too good!"
/// Defines the hustr chatmacro4 text used by the d englsh subsystem.
const HUSTR_CHATMACRO4 = "Help!"
/// Defines the hustr chatmacro5 text used by the d englsh subsystem.
const HUSTR_CHATMACRO5 = "You suck!"
/// Defines the hustr chatmacro6 text used by the d englsh subsystem.
const HUSTR_CHATMACRO6 = "Next time, scumbag..."
/// Defines the hustr chatmacro7 text used by the d englsh subsystem.
const HUSTR_CHATMACRO7 = "Come here!"
/// Defines the hustr chatmacro8 text used by the d englsh subsystem.
const HUSTR_CHATMACRO8 = "I'll take care of it."
/// Defines the hustr chatmacro9 text used by the d englsh subsystem.
const HUSTR_CHATMACRO9 = "Yes"
/// Defines the hustr chatmacro0 text used by the d englsh subsystem.
const HUSTR_CHATMACRO0 = "No"
/// Defines the hustr talktoself1 text used by the d englsh subsystem.
const HUSTR_TALKTOSELF1 = "You mumble to yourself"
/// Defines the hustr talktoself2 text used by the d englsh subsystem.
const HUSTR_TALKTOSELF2 = "Who's there?"
/// Defines the hustr talktoself3 text used by the d englsh subsystem.
const HUSTR_TALKTOSELF3 = "You scare yourself"
/// Defines the hustr talktoself4 text used by the d englsh subsystem.
const HUSTR_TALKTOSELF4 = "You start to rave"
/// Defines the hustr talktoself5 text used by the d englsh subsystem.
const HUSTR_TALKTOSELF5 = "You've lost it..."
/// Defines the hustr messagesent text used by the d englsh subsystem.
const HUSTR_MESSAGESENT = "[Message Sent]"
/// Defines the hustr plrgreen text used by the d englsh subsystem.
const HUSTR_PLRGREEN = "Green: "
/// Defines the hustr plrindigo text used by the d englsh subsystem.
const HUSTR_PLRINDIGO = "Indigo: "
/// Defines the hustr plrbrown text used by the d englsh subsystem.
const HUSTR_PLRBROWN = "Brown: "
/// Defines the hustr plrred text used by the d englsh subsystem.
const HUSTR_PLRRED = "Red: "
/// Defines the hustr keygreen text used by the d englsh subsystem.
const HUSTR_KEYGREEN = "g"
/// Defines the hustr keyindigo text used by the d englsh subsystem.
const HUSTR_KEYINDIGO = "i"
/// Defines the hustr keybrown text used by the d englsh subsystem.
const HUSTR_KEYBROWN = "b"
/// Defines the hustr keyred text used by the d englsh subsystem.
const HUSTR_KEYRED = "r"
/// Defines the amstr followon text used by the d englsh subsystem.
const AMSTR_FOLLOWON = "Follow Mode ON"
/// Defines the amstr followoff text used by the d englsh subsystem.
const AMSTR_FOLLOWOFF = "Follow Mode OFF"
/// Defines the amstr gridon text used by the d englsh subsystem.
const AMSTR_GRIDON = "Grid ON"
/// Defines the amstr gridoff text used by the d englsh subsystem.
const AMSTR_GRIDOFF = "Grid OFF"
/// Defines the amstr markedspot text used by the d englsh subsystem.
const AMSTR_MARKEDSPOT = "Marked Spot"
/// Defines the amstr markscleared text used by the d englsh subsystem.
const AMSTR_MARKSCLEARED = "All Marks Cleared"
/// Defines the ststr mus text used by the d englsh subsystem.
const STSTR_MUS = "Music Change"
/// Defines the ststr nomus text used by the d englsh subsystem.
const STSTR_NOMUS = "IMPOSSIBLE SELECTION"
/// Defines the ststr dqdon text used by the d englsh subsystem.
const STSTR_DQDON = "Degreelessness Mode On"
/// Defines the ststr dqdoff text used by the d englsh subsystem.
const STSTR_DQDOFF = "Degreelessness Mode Off"
/// Defines the ststr kfaadded text used by the d englsh subsystem.
const STSTR_KFAADDED = "Very Happy Ammo Added"
/// Defines the ststr faadded text used by the d englsh subsystem.
const STSTR_FAADDED = "Ammo (no keys) Added"
/// Defines the ststr ncon text used by the d englsh subsystem.
const STSTR_NCON = "No Clipping Mode ON"
/// Defines the ststr ncoff text used by the d englsh subsystem.
const STSTR_NCOFF = "No Clipping Mode OFF"
/// Defines the ststr behold text used by the d englsh subsystem.
const STSTR_BEHOLD = "inVuln, Str, Inviso, Rad, Allmap, or Lite-amp"
/// Defines the ststr beholdx text used by the d englsh subsystem.
const STSTR_BEHOLDX = "Power-up Toggled"
/// Defines the ststr choppers text used by the d englsh subsystem.
const STSTR_CHOPPERS = "... doesn't suck - GM"
/// Defines the ststr clev text used by the d englsh subsystem.
const STSTR_CLEV = "Changing Level..."
/// Defines the e1 text text used by the d englsh subsystem.
const E1TEXT = "Once you beat the big badasses and\nclean out the moon base you're supposed\nto win, aren't you? Aren't you? Where's\nyour fat reward and ticket home? What\nthe hell is this? It's not supposed to\nend this way!\n\nIt stinks like rotten meat, but looks\nlike the lost Deimos base.  Looks like\nyou're stuck on The Shores of Hell.\nThe only way out is through.\n\nTo continue the DOOM experience, play\nThe Shores of Hell and its amazing\nsequel, Inferno!\n"
/// Defines the e2 text text used by the d englsh subsystem.
const E2TEXT = "You've done it! The hideous cyber-\ndemon lord that ruled the lost Deimos\nmoon base has been slain and you\nare triumphant! But ... where are\nyou? You clamber to the edge of the\nmoon and look down to see the awful\ntruth.\n\nDeimos floats above Hell itself!\nYou've never heard of anyone escaping\nfrom Hell, but you'll make the bastards\nsorry they ever heard of you! Quickly,\nyou rappel down to  the surface of\nHell.\n\nNow, it's on to the final chapter of\nDOOM! -- Inferno."
/// Defines the e3 text text used by the d englsh subsystem.
const E3TEXT = "The loathsome spiderdemon that\nmasterminded the invasion of the moon\nbases and caused so much death has had\nits ass kicked for all time.\n\nA hidden doorway opens and you enter.\nYou've proven too tough for Hell to\ncontain, and now Hell at last plays\nfair -- for you emerge from the door\nto see the green fields of Earth!\nHome at last.\n\nYou wonder what's been happening on\nEarth while you were battling evil\nunleashed. It's good that no Hell-\nspawn could have come through that\ndoor with you ..."
/// Defines the e4 text text used by the d englsh subsystem.
const E4TEXT = "the spider mastermind must have sent forth\nits legions of hellspawn before your\nfinal confrontation with that terrible\nbeast from hell.  but you stepped forward\nand brought forth eternal damnation and\nsuffering upon the horde as a true hero\nwould in the face of something so evil.\n\nbesides, someone was gonna pay for what\nhappened to daisy, your pet rabbit.\n\nbut now, you see spread before you more\npotential pain and gibbitude as a nation\nof demons run amok among our cities.\n\nnext stop, hell on earth!"
/// Defines the c1 text text used by the d englsh subsystem.
const C1TEXT = "YOU HAVE ENTERED DEEPLY INTO THE INFESTED\nSTARPORT. BUT SOMETHING IS WRONG. THE\nMONSTERS HAVE BROUGHT THEIR OWN REALITY\nWITH THEM, AND THE STARPORT'S TECHNOLOGY\nIS BEING SUBVERTED BY THEIR PRESENCE.\n\nAHEAD, YOU SEE AN OUTPOST OF HELL, A\nFORTIFIED ZONE. IF YOU CAN GET PAST IT,\nYOU CAN PENETRATE INTO THE HAUNTED HEART\nOF THE STARBASE AND FIND THE CONTROLLING\nSWITCH WHICH HOLDS EARTH'S POPULATION\nHOSTAGE."
/// Defines the c2 text text used by the d englsh subsystem.
const C2TEXT = "YOU HAVE WON! YOUR VICTORY HAS ENABLED\nHUMANKIND TO EVACUATE EARTH AND ESCAPE\nTHE NIGHTMARE.  NOW YOU ARE THE ONLY\nHUMAN LEFT ON THE FACE OF THE PLANET.\nCANNIBAL MUTATIONS, CARNIVOROUS ALIENS,\nAND EVIL SPIRITS ARE YOUR ONLY NEIGHBORS.\nYOU SIT BACK AND WAIT FOR DEATH, CONTENT\nTHAT YOU HAVE SAVED YOUR SPECIES.\n\nBUT THEN, EARTH CONTROL BEAMS DOWN A\nMESSAGE FROM SPACE: \"SENSORS HAVE LOCATED\nTHE SOURCE OF THE ALIEN INVASION. IF YOU\nGO THERE, YOU MAY BE ABLE TO BLOCK THEIR\nENTRY.  THE ALIEN BASE IS IN THE HEART OF\nYOUR OWN HOME CITY, NOT FAR FROM THE\nSTARPORT.\" SLOWLY AND PAINFULLY YOU GET\nUP AND RETURN TO THE FRAY."
/// Defines the c3 text text used by the d englsh subsystem.
const C3TEXT = "YOU ARE AT THE CORRUPT HEART OF THE CITY,\nSURROUNDED BY THE CORPSES OF YOUR ENEMIES.\nYOU SEE NO WAY TO DESTROY THE CREATURES'\nENTRYWAY ON THIS SIDE, SO YOU CLENCH YOUR\nTEETH AND PLUNGE THROUGH IT.\n\nTHERE MUST BE A WAY TO CLOSE IT ON THE\nOTHER SIDE. WHAT DO YOU CARE IF YOU'VE\nGOT TO GO THROUGH HELL TO GET TO IT?"
/// Defines the c4 text text used by the d englsh subsystem.
const C4TEXT = "THE HORRENDOUS VISAGE OF THE BIGGEST\nDEMON YOU'VE EVER SEEN CRUMBLES BEFORE\nYOU, AFTER YOU PUMP YOUR ROCKETS INTO\nHIS EXPOSED BRAIN. THE MONSTER SHRIVELS\nUP AND DIES, ITS THRASHING LIMBS\nDEVASTATING UNTOLD MILES OF HELL'S\nSURFACE.\n\nYOU'VE DONE IT. THE INVASION IS OVER.\nEARTH IS SAVED. HELL IS A WRECK. YOU\nWONDER WHERE BAD FOLKS WILL GO WHEN THEY\nDIE, NOW. WIPING THE SWEAT FROM YOUR\nFOREHEAD YOU BEGIN THE LONG TREK BACK\nHOME. REBUILDING EARTH OUGHT TO BE A\nLOT MORE FUN THAN RUINING IT WAS.\n"
/// Defines the c5 text text used by the d englsh subsystem.
const C5TEXT = "CONGRATULATIONS, YOU'VE FOUND THE SECRET\nLEVEL! LOOKS LIKE IT'S BEEN BUILT BY\nHUMANS, RATHER THAN DEMONS. YOU WONDER\nWHO THE INMATES OF THIS CORNER OF HELL\nWILL BE."
/// Defines the c6 text text used by the d englsh subsystem.
const C6TEXT = "CONGRATULATIONS, YOU'VE FOUND THE\nSUPER SECRET LEVEL!  YOU'D BETTER\nBLAZE THROUGH THIS ONE!\n"
/// Defines the p1 text text used by the d englsh subsystem.
const P1TEXT = "You gloat over the steaming carcass of the\nGuardian.  With its death, you've wrested\nthe Accelerator from the stinking claws\nof Hell.  You relax and glance around the\nroom.  Damn!  There was supposed to be at\nleast one working prototype, but you can't\nsee it. The demons must have taken it.\n\nYou must find the prototype, or all your\nstruggles will have been wasted. Keep\nmoving, keep fighting, keep killing.\nOh yes, keep living, too."
/// Defines the p2 text text used by the d englsh subsystem.
const P2TEXT = "Even the deadly Arch-Vile labyrinth could\nnot stop you, and you've gotten to the\nprototype Accelerator which is soon\nefficiently and permanently deactivated.\n\nYou're good at that kind of thing."
/// Defines the p3 text text used by the d englsh subsystem.
const P3TEXT = "You've bashed and battered your way into\nthe heart of the devil-hive.  Time for a\nSearch-and-Destroy mission, aimed at the\nGatekeeper, whose foul offspring is\ncascading to Earth.  Yeah, he's bad. But\nyou know who's worse!\n\nGrinning evilly, you check your gear, and\nget ready to give the bastard a little Hell\nof your own making!"
/// Defines the p4 text text used by the d englsh subsystem.
const P4TEXT = "The Gatekeeper's evil face is splattered\nall over the place.  As its tattered corpse\ncollapses, an inverted Gate forms and\nsucks down the shards of the last\nprototype Accelerator, not to mention the\nfew remaining demons.  You're done. Hell\nhas gone back to pounding bad dead folks \ninstead of good live ones.  Remember to\ntell your grandkids to put a rocket\nlauncher in your coffin. If you go to Hell\nwhen you die, you'll need it for some\nfinal cleaning-up ..."
/// Defines the p5 text text used by the d englsh subsystem.
const P5TEXT = "You've found the second-hardest level we\ngot. Hope you have a saved game a level or\ntwo previous.  If not, be prepared to die\naplenty. For master marines only."
/// Defines the p6 text text used by the d englsh subsystem.
const P6TEXT = "Betcha wondered just what WAS the hardest\nlevel we had ready for ya?  Now you know.\nNo one gets out alive."
/// Defines the t1 text text used by the d englsh subsystem.
const T1TEXT = "You've fought your way out of the infested\nexperimental labs.   It seems that UAC has\nonce again gulped it down.  With their\nhigh turnover, it must be hard for poor\nold UAC to buy corporate health insurance\nnowadays..\n\nAhead lies the military complex, now\nswarming with diseased horrors hot to get\ntheir teeth into you. With luck, the\ncomplex still has some warlike ordnance\nlaying around."
/// Defines the t2 text text used by the d englsh subsystem.
const T2TEXT = "You hear the grinding of heavy machinery\nahead.  You sure hope they're not stamping\nout new hellspawn, but you're ready to\nream out a whole herd if you have to.\nThey might be planning a blood feast, but\nyou feel about as mean as two thousand\nmaniacs packed into one mad killer.\n\nYou don't plan to go down easy."
/// Defines the t3 text text used by the d englsh subsystem.
const T3TEXT = "The vista opening ahead looks real damn\nfamiliar. Smells familiar, too -- like\nfried excrement. You didn't like this\nplace before, and you sure as hell ain't\nplanning to like it now. The more you\nbrood on it, the madder you get.\nHefting your gun, an evil grin trickles\nonto your face. Time to take some names."
/// Defines the t4 text text used by the d englsh subsystem.
const T4TEXT = "Suddenly, all is silent, from one horizon\nto the other. The agonizing echo of Hell\nfades away, the nightmare sky turns to\nblue, the heaps of monster corpses start \nto evaporate along with the evil stench \nthat filled the air. Jeeze, maybe you've\ndone it. Have you really won?\n\nSomething rumbles in the distance.\nA blue light begins to glow inside the\nruined skull of the demon-spitter."
/// Defines the t5 text text used by the d englsh subsystem.
const T5TEXT = "What now? Looks totally different. Kind\nof like King Tut's condo. Well,\nwhatever's here can't be any worse\nthan usual. Can it?  Or maybe it's best\nto let sleeping gods lie.."
/// Defines the t6 text text used by the d englsh subsystem.
const T6TEXT = "Time for a vacation. You've burst the\nbowels of hell and by golly you're ready\nfor a break. You mutter to yourself,\nMaybe someone else can kick Hell's ass\nnext time around. Ahead lies a quiet town,\nwith peaceful flowing water, quaint\nbuildings, and presumably no Hellspawn.\n\nAs you step off the transport, you hear\nthe stomp of a cyberdemon's iron shoe."
/// Defines the cc zombie text used by the d englsh subsystem.
const CC_ZOMBIE = "ZOMBIEMAN"
/// Defines the cc shotgun text used by the d englsh subsystem.
const CC_SHOTGUN = "SHOTGUN GUY"
/// Defines the cc heavy text used by the d englsh subsystem.
const CC_HEAVY = "HEAVY WEAPON DUDE"
/// Defines the cc imp text used by the d englsh subsystem.
const CC_IMP = "IMP"
/// Defines the cc demon text used by the d englsh subsystem.
const CC_DEMON = "DEMON"
/// Defines the cc lost text used by the d englsh subsystem.
const CC_LOST = "LOST SOUL"
/// Defines the cc caco text used by the d englsh subsystem.
const CC_CACO = "CACODEMON"
/// Defines the cc hell text used by the d englsh subsystem.
const CC_HELL = "HELL KNIGHT"
/// Defines the cc baron text used by the d englsh subsystem.
const CC_BARON = "BARON OF HELL"
/// Defines the cc arach text used by the d englsh subsystem.
const CC_ARACH = "ARACHNOTRON"
/// Defines the cc pain text used by the d englsh subsystem.
const CC_PAIN = "PAIN ELEMENTAL"
/// Defines the cc reven text used by the d englsh subsystem.
const CC_REVEN = "REVENANT"
/// Defines the cc mancu text used by the d englsh subsystem.
const CC_MANCU = "MANCUBUS"
/// Defines the cc arch text used by the d englsh subsystem.
const CC_ARCH = "ARCH-VILE"
/// Defines the cc spider text used by the d englsh subsystem.
const CC_SPIDER = "THE SPIDER MASTERMIND"
/// Defines the cc cyber text used by the d englsh subsystem.
const CC_CYBER = "THE CYBERDEMON"
/// Defines the cc hero text used by the d englsh subsystem.
const CC_HERO = "OUR HERO"



