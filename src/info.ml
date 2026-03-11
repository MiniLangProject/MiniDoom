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

  Script: info.ml
  Purpose: Defines static gameplay tables for states, things, and weapon metadata.
*/
import d_think
import sounds
import m_fixed
import p_mobj

/*
* Enum: spritenum_t
* Purpose: Defines named constants for spritenum type.
*/
enum spritenum_t
  SPR_TROO
  SPR_SHTG
  SPR_PUNG
  SPR_PISG
  SPR_PISF
  SPR_SHTF
  SPR_SHT2
  SPR_CHGG
  SPR_CHGF
  SPR_MISG
  SPR_MISF
  SPR_SAWG
  SPR_PLSG
  SPR_PLSF
  SPR_BFGG
  SPR_BFGF
  SPR_BLUD
  SPR_PUFF
  SPR_BAL1
  SPR_BAL2
  SPR_PLSS
  SPR_PLSE
  SPR_MISL
  SPR_BFS1
  SPR_BFE1
  SPR_BFE2
  SPR_TFOG
  SPR_IFOG
  SPR_PLAY
  SPR_POSS
  SPR_SPOS
  SPR_VILE
  SPR_FIRE
  SPR_FATB
  SPR_FBXP
  SPR_SKEL
  SPR_MANF
  SPR_FATT
  SPR_CPOS
  SPR_SARG
  SPR_HEAD
  SPR_BAL7
  SPR_BOSS
  SPR_BOS2
  SPR_SKUL
  SPR_SPID
  SPR_BSPI
  SPR_APLS
  SPR_APBX
  SPR_CYBR
  SPR_PAIN
  SPR_SSWV
  SPR_KEEN
  SPR_BBRN
  SPR_BOSF
  SPR_ARM1
  SPR_ARM2
  SPR_BAR1
  SPR_BEXP
  SPR_FCAN
  SPR_BON1
  SPR_BON2
  SPR_BKEY
  SPR_RKEY
  SPR_YKEY
  SPR_BSKU
  SPR_RSKU
  SPR_YSKU
  SPR_STIM
  SPR_MEDI
  SPR_SOUL
  SPR_PINV
  SPR_PSTR
  SPR_PINS
  SPR_MEGA
  SPR_SUIT
  SPR_PMAP
  SPR_PVIS
  SPR_CLIP
  SPR_AMMO
  SPR_ROCK
  SPR_BROK
  SPR_CELL
  SPR_CELP
  SPR_SHEL
  SPR_SBOX
  SPR_BPAK
  SPR_BFUG
  SPR_MGUN
  SPR_CSAW
  SPR_LAUN
  SPR_PLAS
  SPR_SHOT
  SPR_SGN2
  SPR_COLU
  SPR_SMT2
  SPR_GOR1
  SPR_POL2
  SPR_POL5
  SPR_POL4
  SPR_POL3
  SPR_POL1
  SPR_POL6
  SPR_GOR2
  SPR_GOR3
  SPR_GOR4
  SPR_GOR5
  SPR_SMIT
  SPR_COL1
  SPR_COL2
  SPR_COL3
  SPR_COL4
  SPR_CAND
  SPR_CBRA
  SPR_COL6
  SPR_TRE1
  SPR_TRE2
  SPR_ELEC
  SPR_CEYE
  SPR_FSKU
  SPR_COL5
  SPR_TBLU
  SPR_TGRN
  SPR_TRED
  SPR_SMBT
  SPR_SMGT
  SPR_SMRT
  SPR_HDB1
  SPR_HDB2
  SPR_HDB3
  SPR_HDB4
  SPR_HDB5
  SPR_HDB6
  SPR_POB1
  SPR_POB2
  SPR_BRS1
  SPR_TLMP
  SPR_TLP2
  NUMSPRITES
end enum

/*
* Enum: statenum_t
* Purpose: Defines named constants for statenum type.
*/
enum statenum_t
  S_NULL
  S_LIGHTDONE
  S_PUNCH
  S_PUNCHDOWN
  S_PUNCHUP
  S_PUNCH1
  S_PUNCH2
  S_PUNCH3
  S_PUNCH4
  S_PUNCH5
  S_PISTOL
  S_PISTOLDOWN
  S_PISTOLUP
  S_PISTOL1
  S_PISTOL2
  S_PISTOL3
  S_PISTOL4
  S_PISTOLFLASH
  S_SGUN
  S_SGUNDOWN
  S_SGUNUP
  S_SGUN1
  S_SGUN2
  S_SGUN3
  S_SGUN4
  S_SGUN5
  S_SGUN6
  S_SGUN7
  S_SGUN8
  S_SGUN9
  S_SGUNFLASH1
  S_SGUNFLASH2
  S_DSGUN
  S_DSGUNDOWN
  S_DSGUNUP
  S_DSGUN1
  S_DSGUN2
  S_DSGUN3
  S_DSGUN4
  S_DSGUN5
  S_DSGUN6
  S_DSGUN7
  S_DSGUN8
  S_DSGUN9
  S_DSGUN10
  S_DSNR1
  S_DSNR2
  S_DSGUNFLASH1
  S_DSGUNFLASH2
  S_CHAIN
  S_CHAINDOWN
  S_CHAINUP
  S_CHAIN1
  S_CHAIN2
  S_CHAIN3
  S_CHAINFLASH1
  S_CHAINFLASH2
  S_MISSILE
  S_MISSILEDOWN
  S_MISSILEUP
  S_MISSILE1
  S_MISSILE2
  S_MISSILE3
  S_MISSILEFLASH1
  S_MISSILEFLASH2
  S_MISSILEFLASH3
  S_MISSILEFLASH4
  S_SAW
  S_SAWB
  S_SAWDOWN
  S_SAWUP
  S_SAW1
  S_SAW2
  S_SAW3
  S_PLASMA
  S_PLASMADOWN
  S_PLASMAUP
  S_PLASMA1
  S_PLASMA2
  S_PLASMAFLASH1
  S_PLASMAFLASH2
  S_BFG
  S_BFGDOWN
  S_BFGUP
  S_BFG1
  S_BFG2
  S_BFG3
  S_BFG4
  S_BFGFLASH1
  S_BFGFLASH2
  S_BLOOD1
  S_BLOOD2
  S_BLOOD3
  S_PUFF1
  S_PUFF2
  S_PUFF3
  S_PUFF4
  S_TBALL1
  S_TBALL2
  S_TBALLX1
  S_TBALLX2
  S_TBALLX3
  S_RBALL1
  S_RBALL2
  S_RBALLX1
  S_RBALLX2
  S_RBALLX3
  S_PLASBALL
  S_PLASBALL2
  S_PLASEXP
  S_PLASEXP2
  S_PLASEXP3
  S_PLASEXP4
  S_PLASEXP5
  S_ROCKET
  S_BFGSHOT
  S_BFGSHOT2
  S_BFGLAND
  S_BFGLAND2
  S_BFGLAND3
  S_BFGLAND4
  S_BFGLAND5
  S_BFGLAND6
  S_BFGEXP
  S_BFGEXP2
  S_BFGEXP3
  S_BFGEXP4
  S_EXPLODE1
  S_EXPLODE2
  S_EXPLODE3
  S_TFOG
  S_TFOG01
  S_TFOG02
  S_TFOG2
  S_TFOG3
  S_TFOG4
  S_TFOG5
  S_TFOG6
  S_TFOG7
  S_TFOG8
  S_TFOG9
  S_TFOG10
  S_IFOG
  S_IFOG01
  S_IFOG02
  S_IFOG2
  S_IFOG3
  S_IFOG4
  S_IFOG5
  S_PLAY
  S_PLAY_RUN1
  S_PLAY_RUN2
  S_PLAY_RUN3
  S_PLAY_RUN4
  S_PLAY_ATK1
  S_PLAY_ATK2
  S_PLAY_PAIN
  S_PLAY_PAIN2
  S_PLAY_DIE1
  S_PLAY_DIE2
  S_PLAY_DIE3
  S_PLAY_DIE4
  S_PLAY_DIE5
  S_PLAY_DIE6
  S_PLAY_DIE7
  S_PLAY_XDIE1
  S_PLAY_XDIE2
  S_PLAY_XDIE3
  S_PLAY_XDIE4
  S_PLAY_XDIE5
  S_PLAY_XDIE6
  S_PLAY_XDIE7
  S_PLAY_XDIE8
  S_PLAY_XDIE9
  S_POSS_STND
  S_POSS_STND2
  S_POSS_RUN1
  S_POSS_RUN2
  S_POSS_RUN3
  S_POSS_RUN4
  S_POSS_RUN5
  S_POSS_RUN6
  S_POSS_RUN7
  S_POSS_RUN8
  S_POSS_ATK1
  S_POSS_ATK2
  S_POSS_ATK3
  S_POSS_PAIN
  S_POSS_PAIN2
  S_POSS_DIE1
  S_POSS_DIE2
  S_POSS_DIE3
  S_POSS_DIE4
  S_POSS_DIE5
  S_POSS_XDIE1
  S_POSS_XDIE2
  S_POSS_XDIE3
  S_POSS_XDIE4
  S_POSS_XDIE5
  S_POSS_XDIE6
  S_POSS_XDIE7
  S_POSS_XDIE8
  S_POSS_XDIE9
  S_POSS_RAISE1
  S_POSS_RAISE2
  S_POSS_RAISE3
  S_POSS_RAISE4
  S_SPOS_STND
  S_SPOS_STND2
  S_SPOS_RUN1
  S_SPOS_RUN2
  S_SPOS_RUN3
  S_SPOS_RUN4
  S_SPOS_RUN5
  S_SPOS_RUN6
  S_SPOS_RUN7
  S_SPOS_RUN8
  S_SPOS_ATK1
  S_SPOS_ATK2
  S_SPOS_ATK3
  S_SPOS_PAIN
  S_SPOS_PAIN2
  S_SPOS_DIE1
  S_SPOS_DIE2
  S_SPOS_DIE3
  S_SPOS_DIE4
  S_SPOS_DIE5
  S_SPOS_XDIE1
  S_SPOS_XDIE2
  S_SPOS_XDIE3
  S_SPOS_XDIE4
  S_SPOS_XDIE5
  S_SPOS_XDIE6
  S_SPOS_XDIE7
  S_SPOS_XDIE8
  S_SPOS_XDIE9
  S_SPOS_RAISE1
  S_SPOS_RAISE2
  S_SPOS_RAISE3
  S_SPOS_RAISE4
  S_SPOS_RAISE5
  S_VILE_STND
  S_VILE_STND2
  S_VILE_RUN1
  S_VILE_RUN2
  S_VILE_RUN3
  S_VILE_RUN4
  S_VILE_RUN5
  S_VILE_RUN6
  S_VILE_RUN7
  S_VILE_RUN8
  S_VILE_RUN9
  S_VILE_RUN10
  S_VILE_RUN11
  S_VILE_RUN12
  S_VILE_ATK1
  S_VILE_ATK2
  S_VILE_ATK3
  S_VILE_ATK4
  S_VILE_ATK5
  S_VILE_ATK6
  S_VILE_ATK7
  S_VILE_ATK8
  S_VILE_ATK9
  S_VILE_ATK10
  S_VILE_ATK11
  S_VILE_HEAL1
  S_VILE_HEAL2
  S_VILE_HEAL3
  S_VILE_PAIN
  S_VILE_PAIN2
  S_VILE_DIE1
  S_VILE_DIE2
  S_VILE_DIE3
  S_VILE_DIE4
  S_VILE_DIE5
  S_VILE_DIE6
  S_VILE_DIE7
  S_VILE_DIE8
  S_VILE_DIE9
  S_VILE_DIE10
  S_FIRE1
  S_FIRE2
  S_FIRE3
  S_FIRE4
  S_FIRE5
  S_FIRE6
  S_FIRE7
  S_FIRE8
  S_FIRE9
  S_FIRE10
  S_FIRE11
  S_FIRE12
  S_FIRE13
  S_FIRE14
  S_FIRE15
  S_FIRE16
  S_FIRE17
  S_FIRE18
  S_FIRE19
  S_FIRE20
  S_FIRE21
  S_FIRE22
  S_FIRE23
  S_FIRE24
  S_FIRE25
  S_FIRE26
  S_FIRE27
  S_FIRE28
  S_FIRE29
  S_FIRE30
  S_SMOKE1
  S_SMOKE2
  S_SMOKE3
  S_SMOKE4
  S_SMOKE5
  S_TRACER
  S_TRACER2
  S_TRACEEXP1
  S_TRACEEXP2
  S_TRACEEXP3
  S_SKEL_STND
  S_SKEL_STND2
  S_SKEL_RUN1
  S_SKEL_RUN2
  S_SKEL_RUN3
  S_SKEL_RUN4
  S_SKEL_RUN5
  S_SKEL_RUN6
  S_SKEL_RUN7
  S_SKEL_RUN8
  S_SKEL_RUN9
  S_SKEL_RUN10
  S_SKEL_RUN11
  S_SKEL_RUN12
  S_SKEL_FIST1
  S_SKEL_FIST2
  S_SKEL_FIST3
  S_SKEL_FIST4
  S_SKEL_MISS1
  S_SKEL_MISS2
  S_SKEL_MISS3
  S_SKEL_MISS4
  S_SKEL_PAIN
  S_SKEL_PAIN2
  S_SKEL_DIE1
  S_SKEL_DIE2
  S_SKEL_DIE3
  S_SKEL_DIE4
  S_SKEL_DIE5
  S_SKEL_DIE6
  S_SKEL_RAISE1
  S_SKEL_RAISE2
  S_SKEL_RAISE3
  S_SKEL_RAISE4
  S_SKEL_RAISE5
  S_SKEL_RAISE6
  S_FATSHOT1
  S_FATSHOT2
  S_FATSHOTX1
  S_FATSHOTX2
  S_FATSHOTX3
  S_FATT_STND
  S_FATT_STND2
  S_FATT_RUN1
  S_FATT_RUN2
  S_FATT_RUN3
  S_FATT_RUN4
  S_FATT_RUN5
  S_FATT_RUN6
  S_FATT_RUN7
  S_FATT_RUN8
  S_FATT_RUN9
  S_FATT_RUN10
  S_FATT_RUN11
  S_FATT_RUN12
  S_FATT_ATK1
  S_FATT_ATK2
  S_FATT_ATK3
  S_FATT_ATK4
  S_FATT_ATK5
  S_FATT_ATK6
  S_FATT_ATK7
  S_FATT_ATK8
  S_FATT_ATK9
  S_FATT_ATK10
  S_FATT_PAIN
  S_FATT_PAIN2
  S_FATT_DIE1
  S_FATT_DIE2
  S_FATT_DIE3
  S_FATT_DIE4
  S_FATT_DIE5
  S_FATT_DIE6
  S_FATT_DIE7
  S_FATT_DIE8
  S_FATT_DIE9
  S_FATT_DIE10
  S_FATT_RAISE1
  S_FATT_RAISE2
  S_FATT_RAISE3
  S_FATT_RAISE4
  S_FATT_RAISE5
  S_FATT_RAISE6
  S_FATT_RAISE7
  S_FATT_RAISE8
  S_CPOS_STND
  S_CPOS_STND2
  S_CPOS_RUN1
  S_CPOS_RUN2
  S_CPOS_RUN3
  S_CPOS_RUN4
  S_CPOS_RUN5
  S_CPOS_RUN6
  S_CPOS_RUN7
  S_CPOS_RUN8
  S_CPOS_ATK1
  S_CPOS_ATK2
  S_CPOS_ATK3
  S_CPOS_ATK4
  S_CPOS_PAIN
  S_CPOS_PAIN2
  S_CPOS_DIE1
  S_CPOS_DIE2
  S_CPOS_DIE3
  S_CPOS_DIE4
  S_CPOS_DIE5
  S_CPOS_DIE6
  S_CPOS_DIE7
  S_CPOS_XDIE1
  S_CPOS_XDIE2
  S_CPOS_XDIE3
  S_CPOS_XDIE4
  S_CPOS_XDIE5
  S_CPOS_XDIE6
  S_CPOS_RAISE1
  S_CPOS_RAISE2
  S_CPOS_RAISE3
  S_CPOS_RAISE4
  S_CPOS_RAISE5
  S_CPOS_RAISE6
  S_CPOS_RAISE7
  S_TROO_STND
  S_TROO_STND2
  S_TROO_RUN1
  S_TROO_RUN2
  S_TROO_RUN3
  S_TROO_RUN4
  S_TROO_RUN5
  S_TROO_RUN6
  S_TROO_RUN7
  S_TROO_RUN8
  S_TROO_ATK1
  S_TROO_ATK2
  S_TROO_ATK3
  S_TROO_PAIN
  S_TROO_PAIN2
  S_TROO_DIE1
  S_TROO_DIE2
  S_TROO_DIE3
  S_TROO_DIE4
  S_TROO_DIE5
  S_TROO_XDIE1
  S_TROO_XDIE2
  S_TROO_XDIE3
  S_TROO_XDIE4
  S_TROO_XDIE5
  S_TROO_XDIE6
  S_TROO_XDIE7
  S_TROO_XDIE8
  S_TROO_RAISE1
  S_TROO_RAISE2
  S_TROO_RAISE3
  S_TROO_RAISE4
  S_TROO_RAISE5
  S_SARG_STND
  S_SARG_STND2
  S_SARG_RUN1
  S_SARG_RUN2
  S_SARG_RUN3
  S_SARG_RUN4
  S_SARG_RUN5
  S_SARG_RUN6
  S_SARG_RUN7
  S_SARG_RUN8
  S_SARG_ATK1
  S_SARG_ATK2
  S_SARG_ATK3
  S_SARG_PAIN
  S_SARG_PAIN2
  S_SARG_DIE1
  S_SARG_DIE2
  S_SARG_DIE3
  S_SARG_DIE4
  S_SARG_DIE5
  S_SARG_DIE6
  S_SARG_RAISE1
  S_SARG_RAISE2
  S_SARG_RAISE3
  S_SARG_RAISE4
  S_SARG_RAISE5
  S_SARG_RAISE6
  S_HEAD_STND
  S_HEAD_RUN1
  S_HEAD_ATK1
  S_HEAD_ATK2
  S_HEAD_ATK3
  S_HEAD_PAIN
  S_HEAD_PAIN2
  S_HEAD_PAIN3
  S_HEAD_DIE1
  S_HEAD_DIE2
  S_HEAD_DIE3
  S_HEAD_DIE4
  S_HEAD_DIE5
  S_HEAD_DIE6
  S_HEAD_RAISE1
  S_HEAD_RAISE2
  S_HEAD_RAISE3
  S_HEAD_RAISE4
  S_HEAD_RAISE5
  S_HEAD_RAISE6
  S_BRBALL1
  S_BRBALL2
  S_BRBALLX1
  S_BRBALLX2
  S_BRBALLX3
  S_BOSS_STND
  S_BOSS_STND2
  S_BOSS_RUN1
  S_BOSS_RUN2
  S_BOSS_RUN3
  S_BOSS_RUN4
  S_BOSS_RUN5
  S_BOSS_RUN6
  S_BOSS_RUN7
  S_BOSS_RUN8
  S_BOSS_ATK1
  S_BOSS_ATK2
  S_BOSS_ATK3
  S_BOSS_PAIN
  S_BOSS_PAIN2
  S_BOSS_DIE1
  S_BOSS_DIE2
  S_BOSS_DIE3
  S_BOSS_DIE4
  S_BOSS_DIE5
  S_BOSS_DIE6
  S_BOSS_DIE7
  S_BOSS_RAISE1
  S_BOSS_RAISE2
  S_BOSS_RAISE3
  S_BOSS_RAISE4
  S_BOSS_RAISE5
  S_BOSS_RAISE6
  S_BOSS_RAISE7
  S_BOS2_STND
  S_BOS2_STND2
  S_BOS2_RUN1
  S_BOS2_RUN2
  S_BOS2_RUN3
  S_BOS2_RUN4
  S_BOS2_RUN5
  S_BOS2_RUN6
  S_BOS2_RUN7
  S_BOS2_RUN8
  S_BOS2_ATK1
  S_BOS2_ATK2
  S_BOS2_ATK3
  S_BOS2_PAIN
  S_BOS2_PAIN2
  S_BOS2_DIE1
  S_BOS2_DIE2
  S_BOS2_DIE3
  S_BOS2_DIE4
  S_BOS2_DIE5
  S_BOS2_DIE6
  S_BOS2_DIE7
  S_BOS2_RAISE1
  S_BOS2_RAISE2
  S_BOS2_RAISE3
  S_BOS2_RAISE4
  S_BOS2_RAISE5
  S_BOS2_RAISE6
  S_BOS2_RAISE7
  S_SKULL_STND
  S_SKULL_STND2
  S_SKULL_RUN1
  S_SKULL_RUN2
  S_SKULL_ATK1
  S_SKULL_ATK2
  S_SKULL_ATK3
  S_SKULL_ATK4
  S_SKULL_PAIN
  S_SKULL_PAIN2
  S_SKULL_DIE1
  S_SKULL_DIE2
  S_SKULL_DIE3
  S_SKULL_DIE4
  S_SKULL_DIE5
  S_SKULL_DIE6
  S_SPID_STND
  S_SPID_STND2
  S_SPID_RUN1
  S_SPID_RUN2
  S_SPID_RUN3
  S_SPID_RUN4
  S_SPID_RUN5
  S_SPID_RUN6
  S_SPID_RUN7
  S_SPID_RUN8
  S_SPID_RUN9
  S_SPID_RUN10
  S_SPID_RUN11
  S_SPID_RUN12
  S_SPID_ATK1
  S_SPID_ATK2
  S_SPID_ATK3
  S_SPID_ATK4
  S_SPID_PAIN
  S_SPID_PAIN2
  S_SPID_DIE1
  S_SPID_DIE2
  S_SPID_DIE3
  S_SPID_DIE4
  S_SPID_DIE5
  S_SPID_DIE6
  S_SPID_DIE7
  S_SPID_DIE8
  S_SPID_DIE9
  S_SPID_DIE10
  S_SPID_DIE11
  S_BSPI_STND
  S_BSPI_STND2
  S_BSPI_SIGHT
  S_BSPI_RUN1
  S_BSPI_RUN2
  S_BSPI_RUN3
  S_BSPI_RUN4
  S_BSPI_RUN5
  S_BSPI_RUN6
  S_BSPI_RUN7
  S_BSPI_RUN8
  S_BSPI_RUN9
  S_BSPI_RUN10
  S_BSPI_RUN11
  S_BSPI_RUN12
  S_BSPI_ATK1
  S_BSPI_ATK2
  S_BSPI_ATK3
  S_BSPI_ATK4
  S_BSPI_PAIN
  S_BSPI_PAIN2
  S_BSPI_DIE1
  S_BSPI_DIE2
  S_BSPI_DIE3
  S_BSPI_DIE4
  S_BSPI_DIE5
  S_BSPI_DIE6
  S_BSPI_DIE7
  S_BSPI_RAISE1
  S_BSPI_RAISE2
  S_BSPI_RAISE3
  S_BSPI_RAISE4
  S_BSPI_RAISE5
  S_BSPI_RAISE6
  S_BSPI_RAISE7
  S_ARACH_PLAZ
  S_ARACH_PLAZ2
  S_ARACH_PLEX
  S_ARACH_PLEX2
  S_ARACH_PLEX3
  S_ARACH_PLEX4
  S_ARACH_PLEX5
  S_CYBER_STND
  S_CYBER_STND2
  S_CYBER_RUN1
  S_CYBER_RUN2
  S_CYBER_RUN3
  S_CYBER_RUN4
  S_CYBER_RUN5
  S_CYBER_RUN6
  S_CYBER_RUN7
  S_CYBER_RUN8
  S_CYBER_ATK1
  S_CYBER_ATK2
  S_CYBER_ATK3
  S_CYBER_ATK4
  S_CYBER_ATK5
  S_CYBER_ATK6
  S_CYBER_PAIN
  S_CYBER_DIE1
  S_CYBER_DIE2
  S_CYBER_DIE3
  S_CYBER_DIE4
  S_CYBER_DIE5
  S_CYBER_DIE6
  S_CYBER_DIE7
  S_CYBER_DIE8
  S_CYBER_DIE9
  S_CYBER_DIE10
  S_PAIN_STND
  S_PAIN_RUN1
  S_PAIN_RUN2
  S_PAIN_RUN3
  S_PAIN_RUN4
  S_PAIN_RUN5
  S_PAIN_RUN6
  S_PAIN_ATK1
  S_PAIN_ATK2
  S_PAIN_ATK3
  S_PAIN_ATK4
  S_PAIN_PAIN
  S_PAIN_PAIN2
  S_PAIN_DIE1
  S_PAIN_DIE2
  S_PAIN_DIE3
  S_PAIN_DIE4
  S_PAIN_DIE5
  S_PAIN_DIE6
  S_PAIN_RAISE1
  S_PAIN_RAISE2
  S_PAIN_RAISE3
  S_PAIN_RAISE4
  S_PAIN_RAISE5
  S_PAIN_RAISE6
  S_SSWV_STND
  S_SSWV_STND2
  S_SSWV_RUN1
  S_SSWV_RUN2
  S_SSWV_RUN3
  S_SSWV_RUN4
  S_SSWV_RUN5
  S_SSWV_RUN6
  S_SSWV_RUN7
  S_SSWV_RUN8
  S_SSWV_ATK1
  S_SSWV_ATK2
  S_SSWV_ATK3
  S_SSWV_ATK4
  S_SSWV_ATK5
  S_SSWV_ATK6
  S_SSWV_PAIN
  S_SSWV_PAIN2
  S_SSWV_DIE1
  S_SSWV_DIE2
  S_SSWV_DIE3
  S_SSWV_DIE4
  S_SSWV_DIE5
  S_SSWV_XDIE1
  S_SSWV_XDIE2
  S_SSWV_XDIE3
  S_SSWV_XDIE4
  S_SSWV_XDIE5
  S_SSWV_XDIE6
  S_SSWV_XDIE7
  S_SSWV_XDIE8
  S_SSWV_XDIE9
  S_SSWV_RAISE1
  S_SSWV_RAISE2
  S_SSWV_RAISE3
  S_SSWV_RAISE4
  S_SSWV_RAISE5
  S_KEENSTND
  S_COMMKEEN
  S_COMMKEEN2
  S_COMMKEEN3
  S_COMMKEEN4
  S_COMMKEEN5
  S_COMMKEEN6
  S_COMMKEEN7
  S_COMMKEEN8
  S_COMMKEEN9
  S_COMMKEEN10
  S_COMMKEEN11
  S_COMMKEEN12
  S_KEENPAIN
  S_KEENPAIN2
  S_BRAIN
  S_BRAIN_PAIN
  S_BRAIN_DIE1
  S_BRAIN_DIE2
  S_BRAIN_DIE3
  S_BRAIN_DIE4
  S_BRAINEYE
  S_BRAINEYESEE
  S_BRAINEYE1
  S_SPAWN1
  S_SPAWN2
  S_SPAWN3
  S_SPAWN4
  S_SPAWNFIRE1
  S_SPAWNFIRE2
  S_SPAWNFIRE3
  S_SPAWNFIRE4
  S_SPAWNFIRE5
  S_SPAWNFIRE6
  S_SPAWNFIRE7
  S_SPAWNFIRE8
  S_BRAINEXPLODE1
  S_BRAINEXPLODE2
  S_BRAINEXPLODE3
  S_ARM1
  S_ARM1A
  S_ARM2
  S_ARM2A
  S_BAR1
  S_BAR2
  S_BEXP
  S_BEXP2
  S_BEXP3
  S_BEXP4
  S_BEXP5
  S_BBAR1
  S_BBAR2
  S_BBAR3
  S_BON1
  S_BON1A
  S_BON1B
  S_BON1C
  S_BON1D
  S_BON1E
  S_BON2
  S_BON2A
  S_BON2B
  S_BON2C
  S_BON2D
  S_BON2E
  S_BKEY
  S_BKEY2
  S_RKEY
  S_RKEY2
  S_YKEY
  S_YKEY2
  S_BSKULL
  S_BSKULL2
  S_RSKULL
  S_RSKULL2
  S_YSKULL
  S_YSKULL2
  S_STIM
  S_MEDI
  S_SOUL
  S_SOUL2
  S_SOUL3
  S_SOUL4
  S_SOUL5
  S_SOUL6
  S_PINV
  S_PINV2
  S_PINV3
  S_PINV4
  S_PSTR
  S_PINS
  S_PINS2
  S_PINS3
  S_PINS4
  S_MEGA
  S_MEGA2
  S_MEGA3
  S_MEGA4
  S_SUIT
  S_PMAP
  S_PMAP2
  S_PMAP3
  S_PMAP4
  S_PMAP5
  S_PMAP6
  S_PVIS
  S_PVIS2
  S_CLIP
  S_AMMO
  S_ROCK
  S_BROK
  S_CELL
  S_CELP
  S_SHEL
  S_SBOX
  S_BPAK
  S_BFUG
  S_MGUN
  S_CSAW
  S_LAUN
  S_PLAS
  S_SHOT
  S_SHOT2
  S_COLU
  S_STALAG
  S_BLOODYTWITCH
  S_BLOODYTWITCH2
  S_BLOODYTWITCH3
  S_BLOODYTWITCH4
  S_DEADTORSO
  S_DEADBOTTOM
  S_HEADSONSTICK
  S_GIBS
  S_HEADONASTICK
  S_HEADCANDLES
  S_HEADCANDLES2
  S_DEADSTICK
  S_LIVESTICK
  S_LIVESTICK2
  S_MEAT2
  S_MEAT3
  S_MEAT4
  S_MEAT5
  S_STALAGTITE
  S_TALLGRNCOL
  S_SHRTGRNCOL
  S_TALLREDCOL
  S_SHRTREDCOL
  S_CANDLESTIK
  S_CANDELABRA
  S_SKULLCOL
  S_TORCHTREE
  S_BIGTREE
  S_TECHPILLAR
  S_EVILEYE
  S_EVILEYE2
  S_EVILEYE3
  S_EVILEYE4
  S_FLOATSKULL
  S_FLOATSKULL2
  S_FLOATSKULL3
  S_HEARTCOL
  S_HEARTCOL2
  S_BLUETORCH
  S_BLUETORCH2
  S_BLUETORCH3
  S_BLUETORCH4
  S_GREENTORCH
  S_GREENTORCH2
  S_GREENTORCH3
  S_GREENTORCH4
  S_REDTORCH
  S_REDTORCH2
  S_REDTORCH3
  S_REDTORCH4
  S_BTORCHSHRT
  S_BTORCHSHRT2
  S_BTORCHSHRT3
  S_BTORCHSHRT4
  S_GTORCHSHRT
  S_GTORCHSHRT2
  S_GTORCHSHRT3
  S_GTORCHSHRT4
  S_RTORCHSHRT
  S_RTORCHSHRT2
  S_RTORCHSHRT3
  S_RTORCHSHRT4
  S_HANGNOGUTS
  S_HANGBNOBRAIN
  S_HANGTLOOKDN
  S_HANGTSKULL
  S_HANGTLOOKUP
  S_HANGTNOBRAIN
  S_COLONGIBS
  S_SMALLPOOL
  S_BRAINSTEM
  S_TECHLAMP
  S_TECHLAMP2
  S_TECHLAMP3
  S_TECHLAMP4
  S_TECH2LAMP
  S_TECH2LAMP2
  S_TECH2LAMP3
  S_TECH2LAMP4
  NUMSTATES
end enum

/*
* Struct: state_t
* Purpose: Stores runtime data for state type.
*/
struct state_t
  sprite
  frame
  tics
  action
  nextstate
  misc1
  misc2
end struct

states =[
state_t(spritenum_t.SPR_TROO, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SHTG, 4, 0, actionf_t(void, void, A_Light0), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PUNG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_PUNCH, 0, 0),
state_t(spritenum_t.SPR_PUNG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_PUNCHDOWN, 0, 0),
state_t(spritenum_t.SPR_PUNG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_PUNCHUP, 0, 0),
state_t(spritenum_t.SPR_PUNG, 1, 4, actionf_t(void, void, void), statenum_t.S_PUNCH2, 0, 0),
state_t(spritenum_t.SPR_PUNG, 2, 4, actionf_t(void, void, A_Punch), statenum_t.S_PUNCH3, 0, 0),
state_t(spritenum_t.SPR_PUNG, 3, 5, actionf_t(void, void, void), statenum_t.S_PUNCH4, 0, 0),
state_t(spritenum_t.SPR_PUNG, 2, 4, actionf_t(void, void, void), statenum_t.S_PUNCH5, 0, 0),
state_t(spritenum_t.SPR_PUNG, 1, 5, actionf_t(void, void, A_ReFire), statenum_t.S_PUNCH, 0, 0),
state_t(spritenum_t.SPR_PISG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_PISTOL, 0, 0),
state_t(spritenum_t.SPR_PISG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_PISTOLDOWN, 0, 0),
state_t(spritenum_t.SPR_PISG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_PISTOLUP, 0, 0),
state_t(spritenum_t.SPR_PISG, 0, 4, actionf_t(void, void, void), statenum_t.S_PISTOL2, 0, 0),
state_t(spritenum_t.SPR_PISG, 1, 6, actionf_t(void, void, A_FirePistol), statenum_t.S_PISTOL3, 0, 0),
state_t(spritenum_t.SPR_PISG, 2, 4, actionf_t(void, void, void), statenum_t.S_PISTOL4, 0, 0),
state_t(spritenum_t.SPR_PISG, 1, 5, actionf_t(void, void, A_ReFire), statenum_t.S_PISTOL, 0, 0),
state_t(spritenum_t.SPR_PISF, 32768, 7, actionf_t(void, void, A_Light1), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_SGUN, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_SGUNDOWN, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_SGUNUP, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 3, actionf_t(void, void, void), statenum_t.S_SGUN2, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 7, actionf_t(void, void, A_FireShotgun), statenum_t.S_SGUN3, 0, 0),
state_t(spritenum_t.SPR_SHTG, 1, 5, actionf_t(void, void, void), statenum_t.S_SGUN4, 0, 0),
state_t(spritenum_t.SPR_SHTG, 2, 5, actionf_t(void, void, void), statenum_t.S_SGUN5, 0, 0),
state_t(spritenum_t.SPR_SHTG, 3, 4, actionf_t(void, void, void), statenum_t.S_SGUN6, 0, 0),
state_t(spritenum_t.SPR_SHTG, 2, 5, actionf_t(void, void, void), statenum_t.S_SGUN7, 0, 0),
state_t(spritenum_t.SPR_SHTG, 1, 5, actionf_t(void, void, void), statenum_t.S_SGUN8, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 3, actionf_t(void, void, void), statenum_t.S_SGUN9, 0, 0),
state_t(spritenum_t.SPR_SHTG, 0, 7, actionf_t(void, void, A_ReFire), statenum_t.S_SGUN, 0, 0),
state_t(spritenum_t.SPR_SHTF, 32768, 4, actionf_t(void, void, A_Light1), statenum_t.S_SGUNFLASH2, 0, 0),
state_t(spritenum_t.SPR_SHTF, 32769, 3, actionf_t(void, void, A_Light2), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_DSGUN, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_DSGUNDOWN, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_DSGUNUP, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 3, actionf_t(void, void, void), statenum_t.S_DSGUN2, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 7, actionf_t(void, void, A_FireShotgun2), statenum_t.S_DSGUN3, 0, 0),
state_t(spritenum_t.SPR_SHT2, 1, 7, actionf_t(void, void, void), statenum_t.S_DSGUN4, 0, 0),
state_t(spritenum_t.SPR_SHT2, 2, 7, actionf_t(void, void, A_CheckReload), statenum_t.S_DSGUN5, 0, 0),
state_t(spritenum_t.SPR_SHT2, 3, 7, actionf_t(A_OpenShotgun2, void, void), statenum_t.S_DSGUN6, 0, 0),
state_t(spritenum_t.SPR_SHT2, 4, 7, actionf_t(void, void, void), statenum_t.S_DSGUN7, 0, 0),
state_t(spritenum_t.SPR_SHT2, 5, 7, actionf_t(A_LoadShotgun2, void, void), statenum_t.S_DSGUN8, 0, 0),
state_t(spritenum_t.SPR_SHT2, 6, 6, actionf_t(void, void, void), statenum_t.S_DSGUN9, 0, 0),
state_t(spritenum_t.SPR_SHT2, 7, 6, actionf_t(A_CloseShotgun2, void, void), statenum_t.S_DSGUN10, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 5, actionf_t(void, void, A_ReFire), statenum_t.S_DSGUN, 0, 0),
state_t(spritenum_t.SPR_SHT2, 1, 7, actionf_t(void, void, void), statenum_t.S_DSNR2, 0, 0),
state_t(spritenum_t.SPR_SHT2, 0, 3, actionf_t(void, void, void), statenum_t.S_DSGUNDOWN, 0, 0),
state_t(spritenum_t.SPR_SHT2, 32776, 5, actionf_t(void, void, A_Light1), statenum_t.S_DSGUNFLASH2, 0, 0),
state_t(spritenum_t.SPR_SHT2, 32777, 4, actionf_t(void, void, A_Light2), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_CHGG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_CHAIN, 0, 0),
state_t(spritenum_t.SPR_CHGG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_CHAINDOWN, 0, 0),
state_t(spritenum_t.SPR_CHGG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_CHAINUP, 0, 0),
state_t(spritenum_t.SPR_CHGG, 0, 4, actionf_t(void, void, A_FireCGun), statenum_t.S_CHAIN2, 0, 0),
state_t(spritenum_t.SPR_CHGG, 1, 4, actionf_t(void, void, A_FireCGun), statenum_t.S_CHAIN3, 0, 0),
state_t(spritenum_t.SPR_CHGG, 1, 0, actionf_t(void, void, A_ReFire), statenum_t.S_CHAIN, 0, 0),
state_t(spritenum_t.SPR_CHGF, 32768, 5, actionf_t(void, void, A_Light1), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_CHGF, 32769, 5, actionf_t(void, void, A_Light2), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_MISG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_MISSILE, 0, 0),
state_t(spritenum_t.SPR_MISG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_MISSILEDOWN, 0, 0),
state_t(spritenum_t.SPR_MISG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_MISSILEUP, 0, 0),
state_t(spritenum_t.SPR_MISG, 1, 8, actionf_t(void, void, A_GunFlash), statenum_t.S_MISSILE2, 0, 0),
state_t(spritenum_t.SPR_MISG, 1, 12, actionf_t(void, void, A_FireMissile), statenum_t.S_MISSILE3, 0, 0),
state_t(spritenum_t.SPR_MISG, 1, 0, actionf_t(void, void, A_ReFire), statenum_t.S_MISSILE, 0, 0),
state_t(spritenum_t.SPR_MISF, 32768, 3, actionf_t(void, void, A_Light1), statenum_t.S_MISSILEFLASH2, 0, 0),
state_t(spritenum_t.SPR_MISF, 32769, 4, actionf_t(void, void, void), statenum_t.S_MISSILEFLASH3, 0, 0),
state_t(spritenum_t.SPR_MISF, 32770, 4, actionf_t(void, void, A_Light2), statenum_t.S_MISSILEFLASH4, 0, 0),
state_t(spritenum_t.SPR_MISF, 32771, 4, actionf_t(void, void, A_Light2), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_SAWG, 2, 4, actionf_t(void, void, A_WeaponReady), statenum_t.S_SAWB, 0, 0),
state_t(spritenum_t.SPR_SAWG, 3, 4, actionf_t(void, void, A_WeaponReady), statenum_t.S_SAW, 0, 0),
state_t(spritenum_t.SPR_SAWG, 2, 1, actionf_t(void, void, A_Lower), statenum_t.S_SAWDOWN, 0, 0),
state_t(spritenum_t.SPR_SAWG, 2, 1, actionf_t(void, void, A_Raise), statenum_t.S_SAWUP, 0, 0),
state_t(spritenum_t.SPR_SAWG, 0, 4, actionf_t(void, void, A_Saw), statenum_t.S_SAW2, 0, 0),
state_t(spritenum_t.SPR_SAWG, 1, 4, actionf_t(void, void, A_Saw), statenum_t.S_SAW3, 0, 0),
state_t(spritenum_t.SPR_SAWG, 1, 0, actionf_t(void, void, A_ReFire), statenum_t.S_SAW, 0, 0),
state_t(spritenum_t.SPR_PLSG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_PLASMA, 0, 0),
state_t(spritenum_t.SPR_PLSG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_PLASMADOWN, 0, 0),
state_t(spritenum_t.SPR_PLSG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_PLASMAUP, 0, 0),
state_t(spritenum_t.SPR_PLSG, 0, 3, actionf_t(void, void, A_FirePlasma), statenum_t.S_PLASMA2, 0, 0),
state_t(spritenum_t.SPR_PLSG, 1, 20, actionf_t(void, void, A_ReFire), statenum_t.S_PLASMA, 0, 0),
state_t(spritenum_t.SPR_PLSF, 32768, 4, actionf_t(void, void, A_Light1), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_PLSF, 32769, 4, actionf_t(void, void, A_Light1), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_BFGG, 0, 1, actionf_t(void, void, A_WeaponReady), statenum_t.S_BFG, 0, 0),
state_t(spritenum_t.SPR_BFGG, 0, 1, actionf_t(void, void, A_Lower), statenum_t.S_BFGDOWN, 0, 0),
state_t(spritenum_t.SPR_BFGG, 0, 1, actionf_t(void, void, A_Raise), statenum_t.S_BFGUP, 0, 0),
state_t(spritenum_t.SPR_BFGG, 0, 20, actionf_t(void, void, A_BFGsound), statenum_t.S_BFG2, 0, 0),
state_t(spritenum_t.SPR_BFGG, 1, 10, actionf_t(void, void, A_GunFlash), statenum_t.S_BFG3, 0, 0),
state_t(spritenum_t.SPR_BFGG, 1, 10, actionf_t(void, void, A_FireBFG), statenum_t.S_BFG4, 0, 0),
state_t(spritenum_t.SPR_BFGG, 1, 20, actionf_t(void, void, A_ReFire), statenum_t.S_BFG, 0, 0),
state_t(spritenum_t.SPR_BFGF, 32768, 11, actionf_t(void, void, A_Light1), statenum_t.S_BFGFLASH2, 0, 0),
state_t(spritenum_t.SPR_BFGF, 32769, 6, actionf_t(void, void, A_Light2), statenum_t.S_LIGHTDONE, 0, 0),
state_t(spritenum_t.SPR_BLUD, 2, 8, actionf_t(void, void, void), statenum_t.S_BLOOD2, 0, 0),
state_t(spritenum_t.SPR_BLUD, 1, 8, actionf_t(void, void, void), statenum_t.S_BLOOD3, 0, 0),
state_t(spritenum_t.SPR_BLUD, 0, 8, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PUFF, 32768, 4, actionf_t(void, void, void), statenum_t.S_PUFF2, 0, 0),
state_t(spritenum_t.SPR_PUFF, 1, 4, actionf_t(void, void, void), statenum_t.S_PUFF3, 0, 0),
state_t(spritenum_t.SPR_PUFF, 2, 4, actionf_t(void, void, void), statenum_t.S_PUFF4, 0, 0),
state_t(spritenum_t.SPR_PUFF, 3, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BAL1, 32768, 4, actionf_t(void, void, void), statenum_t.S_TBALL2, 0, 0),
state_t(spritenum_t.SPR_BAL1, 32769, 4, actionf_t(void, void, void), statenum_t.S_TBALL1, 0, 0),
state_t(spritenum_t.SPR_BAL1, 32770, 6, actionf_t(void, void, void), statenum_t.S_TBALLX2, 0, 0),
state_t(spritenum_t.SPR_BAL1, 32771, 6, actionf_t(void, void, void), statenum_t.S_TBALLX3, 0, 0),
state_t(spritenum_t.SPR_BAL1, 32772, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BAL2, 32768, 4, actionf_t(void, void, void), statenum_t.S_RBALL2, 0, 0),
state_t(spritenum_t.SPR_BAL2, 32769, 4, actionf_t(void, void, void), statenum_t.S_RBALL1, 0, 0),
state_t(spritenum_t.SPR_BAL2, 32770, 6, actionf_t(void, void, void), statenum_t.S_RBALLX2, 0, 0),
state_t(spritenum_t.SPR_BAL2, 32771, 6, actionf_t(void, void, void), statenum_t.S_RBALLX3, 0, 0),
state_t(spritenum_t.SPR_BAL2, 32772, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLSS, 32768, 6, actionf_t(void, void, void), statenum_t.S_PLASBALL2, 0, 0),
state_t(spritenum_t.SPR_PLSS, 32769, 6, actionf_t(void, void, void), statenum_t.S_PLASBALL, 0, 0),
state_t(spritenum_t.SPR_PLSE, 32768, 4, actionf_t(void, void, void), statenum_t.S_PLASEXP2, 0, 0),
state_t(spritenum_t.SPR_PLSE, 32769, 4, actionf_t(void, void, void), statenum_t.S_PLASEXP3, 0, 0),
state_t(spritenum_t.SPR_PLSE, 32770, 4, actionf_t(void, void, void), statenum_t.S_PLASEXP4, 0, 0),
state_t(spritenum_t.SPR_PLSE, 32771, 4, actionf_t(void, void, void), statenum_t.S_PLASEXP5, 0, 0),
state_t(spritenum_t.SPR_PLSE, 32772, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_MISL, 32768, 1, actionf_t(void, void, void), statenum_t.S_ROCKET, 0, 0),
state_t(spritenum_t.SPR_BFS1, 32768, 4, actionf_t(void, void, void), statenum_t.S_BFGSHOT2, 0, 0),
state_t(spritenum_t.SPR_BFS1, 32769, 4, actionf_t(void, void, void), statenum_t.S_BFGSHOT, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32768, 8, actionf_t(void, void, void), statenum_t.S_BFGLAND2, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32769, 8, actionf_t(void, void, void), statenum_t.S_BFGLAND3, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32770, 8, actionf_t(A_BFGSpray, void, void), statenum_t.S_BFGLAND4, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32771, 8, actionf_t(void, void, void), statenum_t.S_BFGLAND5, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32772, 8, actionf_t(void, void, void), statenum_t.S_BFGLAND6, 0, 0),
state_t(spritenum_t.SPR_BFE1, 32773, 8, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BFE2, 32768, 8, actionf_t(void, void, void), statenum_t.S_BFGEXP2, 0, 0),
state_t(spritenum_t.SPR_BFE2, 32769, 8, actionf_t(void, void, void), statenum_t.S_BFGEXP3, 0, 0),
state_t(spritenum_t.SPR_BFE2, 32770, 8, actionf_t(void, void, void), statenum_t.S_BFGEXP4, 0, 0),
state_t(spritenum_t.SPR_BFE2, 32771, 8, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_MISL, 32769, 8, actionf_t(A_Explode, void, void), statenum_t.S_EXPLODE2, 0, 0),
state_t(spritenum_t.SPR_MISL, 32770, 6, actionf_t(void, void, void), statenum_t.S_EXPLODE3, 0, 0),
state_t(spritenum_t.SPR_MISL, 32771, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32768, 6, actionf_t(void, void, void), statenum_t.S_TFOG01, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32769, 6, actionf_t(void, void, void), statenum_t.S_TFOG02, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32768, 6, actionf_t(void, void, void), statenum_t.S_TFOG2, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32769, 6, actionf_t(void, void, void), statenum_t.S_TFOG3, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32770, 6, actionf_t(void, void, void), statenum_t.S_TFOG4, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32771, 6, actionf_t(void, void, void), statenum_t.S_TFOG5, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32772, 6, actionf_t(void, void, void), statenum_t.S_TFOG6, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32773, 6, actionf_t(void, void, void), statenum_t.S_TFOG7, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32774, 6, actionf_t(void, void, void), statenum_t.S_TFOG8, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32775, 6, actionf_t(void, void, void), statenum_t.S_TFOG9, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32776, 6, actionf_t(void, void, void), statenum_t.S_TFOG10, 0, 0),
state_t(spritenum_t.SPR_TFOG, 32777, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32768, 6, actionf_t(void, void, void), statenum_t.S_IFOG01, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32769, 6, actionf_t(void, void, void), statenum_t.S_IFOG02, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32768, 6, actionf_t(void, void, void), statenum_t.S_IFOG2, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32769, 6, actionf_t(void, void, void), statenum_t.S_IFOG3, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32770, 6, actionf_t(void, void, void), statenum_t.S_IFOG4, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32771, 6, actionf_t(void, void, void), statenum_t.S_IFOG5, 0, 0),
state_t(spritenum_t.SPR_IFOG, 32772, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLAY, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLAY, 0, 4, actionf_t(void, void, void), statenum_t.S_PLAY_RUN2, 0, 0),
state_t(spritenum_t.SPR_PLAY, 1, 4, actionf_t(void, void, void), statenum_t.S_PLAY_RUN3, 0, 0),
state_t(spritenum_t.SPR_PLAY, 2, 4, actionf_t(void, void, void), statenum_t.S_PLAY_RUN4, 0, 0),
state_t(spritenum_t.SPR_PLAY, 3, 4, actionf_t(void, void, void), statenum_t.S_PLAY_RUN1, 0, 0),
state_t(spritenum_t.SPR_PLAY, 4, 12, actionf_t(void, void, void), statenum_t.S_PLAY, 0, 0),
state_t(spritenum_t.SPR_PLAY, 32773, 6, actionf_t(void, void, void), statenum_t.S_PLAY_ATK1, 0, 0),
state_t(spritenum_t.SPR_PLAY, 6, 4, actionf_t(void, void, void), statenum_t.S_PLAY_PAIN2, 0, 0),
state_t(spritenum_t.SPR_PLAY, 6, 4, actionf_t(A_Pain, void, void), statenum_t.S_PLAY, 0, 0),
state_t(spritenum_t.SPR_PLAY, 7, 10, actionf_t(void, void, void), statenum_t.S_PLAY_DIE2, 0, 0),
state_t(spritenum_t.SPR_PLAY, 8, 10, actionf_t(A_PlayerScream, void, void), statenum_t.S_PLAY_DIE3, 0, 0),
state_t(spritenum_t.SPR_PLAY, 9, 10, actionf_t(A_Fall, void, void), statenum_t.S_PLAY_DIE4, 0, 0),
state_t(spritenum_t.SPR_PLAY, 10, 10, actionf_t(void, void, void), statenum_t.S_PLAY_DIE5, 0, 0),
state_t(spritenum_t.SPR_PLAY, 11, 10, actionf_t(void, void, void), statenum_t.S_PLAY_DIE6, 0, 0),
state_t(spritenum_t.SPR_PLAY, 12, 10, actionf_t(void, void, void), statenum_t.S_PLAY_DIE7, 0, 0),
state_t(spritenum_t.SPR_PLAY, 13, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLAY, 14, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE2, 0, 0),
state_t(spritenum_t.SPR_PLAY, 15, 5, actionf_t(A_XScream, void, void), statenum_t.S_PLAY_XDIE3, 0, 0),
state_t(spritenum_t.SPR_PLAY, 16, 5, actionf_t(A_Fall, void, void), statenum_t.S_PLAY_XDIE4, 0, 0),
state_t(spritenum_t.SPR_PLAY, 17, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE5, 0, 0),
state_t(spritenum_t.SPR_PLAY, 18, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE6, 0, 0),
state_t(spritenum_t.SPR_PLAY, 19, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE7, 0, 0),
state_t(spritenum_t.SPR_PLAY, 20, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE8, 0, 0),
state_t(spritenum_t.SPR_PLAY, 21, 5, actionf_t(void, void, void), statenum_t.S_PLAY_XDIE9, 0, 0),
state_t(spritenum_t.SPR_PLAY, 22, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POSS, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_POSS_STND2, 0, 0),
state_t(spritenum_t.SPR_POSS, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_POSS_STND, 0, 0),
state_t(spritenum_t.SPR_POSS, 0, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN2, 0, 0),
state_t(spritenum_t.SPR_POSS, 0, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN3, 0, 0),
state_t(spritenum_t.SPR_POSS, 1, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN4, 0, 0),
state_t(spritenum_t.SPR_POSS, 1, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN5, 0, 0),
state_t(spritenum_t.SPR_POSS, 2, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN6, 0, 0),
state_t(spritenum_t.SPR_POSS, 2, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN7, 0, 0),
state_t(spritenum_t.SPR_POSS, 3, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN8, 0, 0),
state_t(spritenum_t.SPR_POSS, 3, 4, actionf_t(A_Chase, void, void), statenum_t.S_POSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_POSS, 4, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_POSS_ATK2, 0, 0),
state_t(spritenum_t.SPR_POSS, 5, 8, actionf_t(A_PosAttack, void, void), statenum_t.S_POSS_ATK3, 0, 0),
state_t(spritenum_t.SPR_POSS, 4, 8, actionf_t(void, void, void), statenum_t.S_POSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_POSS, 6, 3, actionf_t(void, void, void), statenum_t.S_POSS_PAIN2, 0, 0),
state_t(spritenum_t.SPR_POSS, 6, 3, actionf_t(A_Pain, void, void), statenum_t.S_POSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_POSS, 7, 5, actionf_t(void, void, void), statenum_t.S_POSS_DIE2, 0, 0),
state_t(spritenum_t.SPR_POSS, 8, 5, actionf_t(A_Scream, void, void), statenum_t.S_POSS_DIE3, 0, 0),
state_t(spritenum_t.SPR_POSS, 9, 5, actionf_t(A_Fall, void, void), statenum_t.S_POSS_DIE4, 0, 0),
state_t(spritenum_t.SPR_POSS, 10, 5, actionf_t(void, void, void), statenum_t.S_POSS_DIE5, 0, 0),
state_t(spritenum_t.SPR_POSS, 11, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POSS, 12, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE2, 0, 0),
state_t(spritenum_t.SPR_POSS, 13, 5, actionf_t(A_XScream, void, void), statenum_t.S_POSS_XDIE3, 0, 0),
state_t(spritenum_t.SPR_POSS, 14, 5, actionf_t(A_Fall, void, void), statenum_t.S_POSS_XDIE4, 0, 0),
state_t(spritenum_t.SPR_POSS, 15, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE5, 0, 0),
state_t(spritenum_t.SPR_POSS, 16, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE6, 0, 0),
state_t(spritenum_t.SPR_POSS, 17, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE7, 0, 0),
state_t(spritenum_t.SPR_POSS, 18, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE8, 0, 0),
state_t(spritenum_t.SPR_POSS, 19, 5, actionf_t(void, void, void), statenum_t.S_POSS_XDIE9, 0, 0),
state_t(spritenum_t.SPR_POSS, 20, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POSS, 10, 5, actionf_t(void, void, void), statenum_t.S_POSS_RAISE2, 0, 0),
state_t(spritenum_t.SPR_POSS, 9, 5, actionf_t(void, void, void), statenum_t.S_POSS_RAISE3, 0, 0),
state_t(spritenum_t.SPR_POSS, 8, 5, actionf_t(void, void, void), statenum_t.S_POSS_RAISE4, 0, 0),
state_t(spritenum_t.SPR_POSS, 7, 5, actionf_t(void, void, void), statenum_t.S_POSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPOS, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_SPOS_STND2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_SPOS_STND, 0, 0),
state_t(spritenum_t.SPR_SPOS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN3, 0, 0),
state_t(spritenum_t.SPR_SPOS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN4, 0, 0),
state_t(spritenum_t.SPR_SPOS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN5, 0, 0),
state_t(spritenum_t.SPR_SPOS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN6, 0, 0),
state_t(spritenum_t.SPR_SPOS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN7, 0, 0),
state_t(spritenum_t.SPR_SPOS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN8, 0, 0),
state_t(spritenum_t.SPR_SPOS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPOS, 4, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SPOS_ATK2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 32773, 10, actionf_t(A_SPosAttack, void, void), statenum_t.S_SPOS_ATK3, 0, 0),
state_t(spritenum_t.SPR_SPOS, 4, 10, actionf_t(void, void, void), statenum_t.S_SPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPOS, 6, 3, actionf_t(void, void, void), statenum_t.S_SPOS_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 6, 3, actionf_t(A_Pain, void, void), statenum_t.S_SPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPOS, 7, 5, actionf_t(void, void, void), statenum_t.S_SPOS_DIE2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 8, 5, actionf_t(A_Scream, void, void), statenum_t.S_SPOS_DIE3, 0, 0),
state_t(spritenum_t.SPR_SPOS, 9, 5, actionf_t(A_Fall, void, void), statenum_t.S_SPOS_DIE4, 0, 0),
state_t(spritenum_t.SPR_SPOS, 10, 5, actionf_t(void, void, void), statenum_t.S_SPOS_DIE5, 0, 0),
state_t(spritenum_t.SPR_SPOS, 11, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SPOS, 12, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 13, 5, actionf_t(A_XScream, void, void), statenum_t.S_SPOS_XDIE3, 0, 0),
state_t(spritenum_t.SPR_SPOS, 14, 5, actionf_t(A_Fall, void, void), statenum_t.S_SPOS_XDIE4, 0, 0),
state_t(spritenum_t.SPR_SPOS, 15, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE5, 0, 0),
state_t(spritenum_t.SPR_SPOS, 16, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE6, 0, 0),
state_t(spritenum_t.SPR_SPOS, 17, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE7, 0, 0),
state_t(spritenum_t.SPR_SPOS, 18, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE8, 0, 0),
state_t(spritenum_t.SPR_SPOS, 19, 5, actionf_t(void, void, void), statenum_t.S_SPOS_XDIE9, 0, 0),
state_t(spritenum_t.SPR_SPOS, 20, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SPOS, 11, 5, actionf_t(void, void, void), statenum_t.S_SPOS_RAISE2, 0, 0),
state_t(spritenum_t.SPR_SPOS, 10, 5, actionf_t(void, void, void), statenum_t.S_SPOS_RAISE3, 0, 0),
state_t(spritenum_t.SPR_SPOS, 9, 5, actionf_t(void, void, void), statenum_t.S_SPOS_RAISE4, 0, 0),
state_t(spritenum_t.SPR_SPOS, 8, 5, actionf_t(void, void, void), statenum_t.S_SPOS_RAISE5, 0, 0),
state_t(spritenum_t.SPR_SPOS, 7, 5, actionf_t(void, void, void), statenum_t.S_SPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_VILE, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_VILE_STND2, 0, 0),
state_t(spritenum_t.SPR_VILE, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_VILE_STND, 0, 0),
state_t(spritenum_t.SPR_VILE, 0, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN2, 0, 0),
state_t(spritenum_t.SPR_VILE, 0, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN3, 0, 0),
state_t(spritenum_t.SPR_VILE, 1, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN4, 0, 0),
state_t(spritenum_t.SPR_VILE, 1, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN5, 0, 0),
state_t(spritenum_t.SPR_VILE, 2, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN6, 0, 0),
state_t(spritenum_t.SPR_VILE, 2, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN7, 0, 0),
state_t(spritenum_t.SPR_VILE, 3, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN8, 0, 0),
state_t(spritenum_t.SPR_VILE, 3, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN9, 0, 0),
state_t(spritenum_t.SPR_VILE, 4, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN10, 0, 0),
state_t(spritenum_t.SPR_VILE, 4, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN11, 0, 0),
state_t(spritenum_t.SPR_VILE, 5, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN12, 0, 0),
state_t(spritenum_t.SPR_VILE, 5, 2, actionf_t(A_VileChase, void, void), statenum_t.S_VILE_RUN1, 0, 0),
state_t(spritenum_t.SPR_VILE, 32774, 0, actionf_t(A_VileStart, void, void), statenum_t.S_VILE_ATK2, 0, 0),
state_t(spritenum_t.SPR_VILE, 32774, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK3, 0, 0),
state_t(spritenum_t.SPR_VILE, 32775, 8, actionf_t(A_VileTarget, void, void), statenum_t.S_VILE_ATK4, 0, 0),
state_t(spritenum_t.SPR_VILE, 32776, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK5, 0, 0),
state_t(spritenum_t.SPR_VILE, 32777, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK6, 0, 0),
state_t(spritenum_t.SPR_VILE, 32778, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK7, 0, 0),
state_t(spritenum_t.SPR_VILE, 32779, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK8, 0, 0),
state_t(spritenum_t.SPR_VILE, 32780, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK9, 0, 0),
state_t(spritenum_t.SPR_VILE, 32781, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_VILE_ATK10, 0, 0),
state_t(spritenum_t.SPR_VILE, 32782, 8, actionf_t(A_VileAttack, void, void), statenum_t.S_VILE_ATK11, 0, 0),
state_t(spritenum_t.SPR_VILE, 32783, 20, actionf_t(void, void, void), statenum_t.S_VILE_RUN1, 0, 0),
state_t(spritenum_t.SPR_VILE, 32794, 10, actionf_t(void, void, void), statenum_t.S_VILE_HEAL2, 0, 0),
state_t(spritenum_t.SPR_VILE, 32795, 10, actionf_t(void, void, void), statenum_t.S_VILE_HEAL3, 0, 0),
state_t(spritenum_t.SPR_VILE, 32796, 10, actionf_t(void, void, void), statenum_t.S_VILE_RUN1, 0, 0),
state_t(spritenum_t.SPR_VILE, 16, 5, actionf_t(void, void, void), statenum_t.S_VILE_PAIN2, 0, 0),
state_t(spritenum_t.SPR_VILE, 16, 5, actionf_t(A_Pain, void, void), statenum_t.S_VILE_RUN1, 0, 0),
state_t(spritenum_t.SPR_VILE, 16, 7, actionf_t(void, void, void), statenum_t.S_VILE_DIE2, 0, 0),
state_t(spritenum_t.SPR_VILE, 17, 7, actionf_t(A_Scream, void, void), statenum_t.S_VILE_DIE3, 0, 0),
state_t(spritenum_t.SPR_VILE, 18, 7, actionf_t(A_Fall, void, void), statenum_t.S_VILE_DIE4, 0, 0),
state_t(spritenum_t.SPR_VILE, 19, 7, actionf_t(void, void, void), statenum_t.S_VILE_DIE5, 0, 0),
state_t(spritenum_t.SPR_VILE, 20, 7, actionf_t(void, void, void), statenum_t.S_VILE_DIE6, 0, 0),
state_t(spritenum_t.SPR_VILE, 21, 7, actionf_t(void, void, void), statenum_t.S_VILE_DIE7, 0, 0),
state_t(spritenum_t.SPR_VILE, 22, 7, actionf_t(void, void, void), statenum_t.S_VILE_DIE8, 0, 0),
state_t(spritenum_t.SPR_VILE, 23, 5, actionf_t(void, void, void), statenum_t.S_VILE_DIE9, 0, 0),
state_t(spritenum_t.SPR_VILE, 24, 5, actionf_t(void, void, void), statenum_t.S_VILE_DIE10, 0, 0),
state_t(spritenum_t.SPR_VILE, 25, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32768, 2, actionf_t(A_StartFire, void, void), statenum_t.S_FIRE2, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32769, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE3, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32768, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE4, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32769, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE5, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 2, actionf_t(A_FireCrackle, void, void), statenum_t.S_FIRE6, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32769, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE7, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE8, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32769, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE9, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE10, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE11, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE12, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE13, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE14, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE15, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE16, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE17, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE18, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE19, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 2, actionf_t(A_FireCrackle, void, void), statenum_t.S_FIRE20, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32773, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE21, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE22, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32773, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE23, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE24, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32773, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE25, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32774, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE26, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32775, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE27, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32774, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE28, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32775, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE29, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32774, 2, actionf_t(A_Fire, void, void), statenum_t.S_FIRE30, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32775, 2, actionf_t(A_Fire, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PUFF, 1, 4, actionf_t(void, void, void), statenum_t.S_SMOKE2, 0, 0),
state_t(spritenum_t.SPR_PUFF, 2, 4, actionf_t(void, void, void), statenum_t.S_SMOKE3, 0, 0),
state_t(spritenum_t.SPR_PUFF, 1, 4, actionf_t(void, void, void), statenum_t.S_SMOKE4, 0, 0),
state_t(spritenum_t.SPR_PUFF, 2, 4, actionf_t(void, void, void), statenum_t.S_SMOKE5, 0, 0),
state_t(spritenum_t.SPR_PUFF, 3, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_FATB, 32768, 2, actionf_t(A_Tracer, void, void), statenum_t.S_TRACER2, 0, 0),
state_t(spritenum_t.SPR_FATB, 32769, 2, actionf_t(A_Tracer, void, void), statenum_t.S_TRACER, 0, 0),
state_t(spritenum_t.SPR_FBXP, 32768, 8, actionf_t(void, void, void), statenum_t.S_TRACEEXP2, 0, 0),
state_t(spritenum_t.SPR_FBXP, 32769, 6, actionf_t(void, void, void), statenum_t.S_TRACEEXP3, 0, 0),
state_t(spritenum_t.SPR_FBXP, 32770, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SKEL, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_SKEL_STND2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_SKEL_STND, 0, 0),
state_t(spritenum_t.SPR_SKEL, 0, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 0, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN3, 0, 0),
state_t(spritenum_t.SPR_SKEL, 1, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN4, 0, 0),
state_t(spritenum_t.SPR_SKEL, 1, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN5, 0, 0),
state_t(spritenum_t.SPR_SKEL, 2, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN6, 0, 0),
state_t(spritenum_t.SPR_SKEL, 2, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN7, 0, 0),
state_t(spritenum_t.SPR_SKEL, 3, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN8, 0, 0),
state_t(spritenum_t.SPR_SKEL, 3, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN9, 0, 0),
state_t(spritenum_t.SPR_SKEL, 4, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN10, 0, 0),
state_t(spritenum_t.SPR_SKEL, 4, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN11, 0, 0),
state_t(spritenum_t.SPR_SKEL, 5, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN12, 0, 0),
state_t(spritenum_t.SPR_SKEL, 5, 2, actionf_t(A_Chase, void, void), statenum_t.S_SKEL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKEL, 6, 0, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKEL_FIST2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 6, 6, actionf_t(A_SkelWhoosh, void, void), statenum_t.S_SKEL_FIST3, 0, 0),
state_t(spritenum_t.SPR_SKEL, 7, 6, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKEL_FIST4, 0, 0),
state_t(spritenum_t.SPR_SKEL, 8, 6, actionf_t(A_SkelFist, void, void), statenum_t.S_SKEL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKEL, 32777, 0, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKEL_MISS2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 32777, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKEL_MISS3, 0, 0),
state_t(spritenum_t.SPR_SKEL, 10, 10, actionf_t(A_SkelMissile, void, void), statenum_t.S_SKEL_MISS4, 0, 0),
state_t(spritenum_t.SPR_SKEL, 10, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKEL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKEL, 11, 5, actionf_t(void, void, void), statenum_t.S_SKEL_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 11, 5, actionf_t(A_Pain, void, void), statenum_t.S_SKEL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKEL, 11, 7, actionf_t(void, void, void), statenum_t.S_SKEL_DIE2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 12, 7, actionf_t(void, void, void), statenum_t.S_SKEL_DIE3, 0, 0),
state_t(spritenum_t.SPR_SKEL, 13, 7, actionf_t(A_Scream, void, void), statenum_t.S_SKEL_DIE4, 0, 0),
state_t(spritenum_t.SPR_SKEL, 14, 7, actionf_t(A_Fall, void, void), statenum_t.S_SKEL_DIE5, 0, 0),
state_t(spritenum_t.SPR_SKEL, 15, 7, actionf_t(void, void, void), statenum_t.S_SKEL_DIE6, 0, 0),
state_t(spritenum_t.SPR_SKEL, 16, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SKEL, 16, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RAISE2, 0, 0),
state_t(spritenum_t.SPR_SKEL, 15, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RAISE3, 0, 0),
state_t(spritenum_t.SPR_SKEL, 14, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RAISE4, 0, 0),
state_t(spritenum_t.SPR_SKEL, 13, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RAISE5, 0, 0),
state_t(spritenum_t.SPR_SKEL, 12, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RAISE6, 0, 0),
state_t(spritenum_t.SPR_SKEL, 11, 5, actionf_t(void, void, void), statenum_t.S_SKEL_RUN1, 0, 0),
state_t(spritenum_t.SPR_MANF, 32768, 4, actionf_t(void, void, void), statenum_t.S_FATSHOT2, 0, 0),
state_t(spritenum_t.SPR_MANF, 32769, 4, actionf_t(void, void, void), statenum_t.S_FATSHOT1, 0, 0),
state_t(spritenum_t.SPR_MISL, 32769, 8, actionf_t(void, void, void), statenum_t.S_FATSHOTX2, 0, 0),
state_t(spritenum_t.SPR_MISL, 32770, 6, actionf_t(void, void, void), statenum_t.S_FATSHOTX3, 0, 0),
state_t(spritenum_t.SPR_MISL, 32771, 4, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_FATT, 0, 15, actionf_t(A_Look, void, void), statenum_t.S_FATT_STND2, 0, 0),
state_t(spritenum_t.SPR_FATT, 1, 15, actionf_t(A_Look, void, void), statenum_t.S_FATT_STND, 0, 0),
state_t(spritenum_t.SPR_FATT, 0, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN2, 0, 0),
state_t(spritenum_t.SPR_FATT, 0, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN3, 0, 0),
state_t(spritenum_t.SPR_FATT, 1, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN4, 0, 0),
state_t(spritenum_t.SPR_FATT, 1, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN5, 0, 0),
state_t(spritenum_t.SPR_FATT, 2, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN6, 0, 0),
state_t(spritenum_t.SPR_FATT, 2, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN7, 0, 0),
state_t(spritenum_t.SPR_FATT, 3, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN8, 0, 0),
state_t(spritenum_t.SPR_FATT, 3, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN9, 0, 0),
state_t(spritenum_t.SPR_FATT, 4, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN10, 0, 0),
state_t(spritenum_t.SPR_FATT, 4, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN11, 0, 0),
state_t(spritenum_t.SPR_FATT, 5, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN12, 0, 0),
state_t(spritenum_t.SPR_FATT, 5, 4, actionf_t(A_Chase, void, void), statenum_t.S_FATT_RUN1, 0, 0),
state_t(spritenum_t.SPR_FATT, 6, 20, actionf_t(A_FatRaise, void, void), statenum_t.S_FATT_ATK2, 0, 0),
state_t(spritenum_t.SPR_FATT, 32775, 10, actionf_t(A_FatAttack1, void, void), statenum_t.S_FATT_ATK3, 0, 0),
state_t(spritenum_t.SPR_FATT, 8, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_ATK4, 0, 0),
state_t(spritenum_t.SPR_FATT, 6, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_ATK5, 0, 0),
state_t(spritenum_t.SPR_FATT, 32775, 10, actionf_t(A_FatAttack2, void, void), statenum_t.S_FATT_ATK6, 0, 0),
state_t(spritenum_t.SPR_FATT, 8, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_ATK7, 0, 0),
state_t(spritenum_t.SPR_FATT, 6, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_ATK8, 0, 0),
state_t(spritenum_t.SPR_FATT, 32775, 10, actionf_t(A_FatAttack3, void, void), statenum_t.S_FATT_ATK9, 0, 0),
state_t(spritenum_t.SPR_FATT, 8, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_ATK10, 0, 0),
state_t(spritenum_t.SPR_FATT, 6, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_FATT_RUN1, 0, 0),
state_t(spritenum_t.SPR_FATT, 9, 3, actionf_t(void, void, void), statenum_t.S_FATT_PAIN2, 0, 0),
state_t(spritenum_t.SPR_FATT, 9, 3, actionf_t(A_Pain, void, void), statenum_t.S_FATT_RUN1, 0, 0),
state_t(spritenum_t.SPR_FATT, 10, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE2, 0, 0),
state_t(spritenum_t.SPR_FATT, 11, 6, actionf_t(A_Scream, void, void), statenum_t.S_FATT_DIE3, 0, 0),
state_t(spritenum_t.SPR_FATT, 12, 6, actionf_t(A_Fall, void, void), statenum_t.S_FATT_DIE4, 0, 0),
state_t(spritenum_t.SPR_FATT, 13, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE5, 0, 0),
state_t(spritenum_t.SPR_FATT, 14, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE6, 0, 0),
state_t(spritenum_t.SPR_FATT, 15, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE7, 0, 0),
state_t(spritenum_t.SPR_FATT, 16, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE8, 0, 0),
state_t(spritenum_t.SPR_FATT, 17, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE9, 0, 0),
state_t(spritenum_t.SPR_FATT, 18, 6, actionf_t(void, void, void), statenum_t.S_FATT_DIE10, 0, 0),
state_t(spritenum_t.SPR_FATT, 19, -1, actionf_t(A_BossDeath, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_FATT, 17, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE2, 0, 0),
state_t(spritenum_t.SPR_FATT, 16, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE3, 0, 0),
state_t(spritenum_t.SPR_FATT, 15, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE4, 0, 0),
state_t(spritenum_t.SPR_FATT, 14, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE5, 0, 0),
state_t(spritenum_t.SPR_FATT, 13, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE6, 0, 0),
state_t(spritenum_t.SPR_FATT, 12, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE7, 0, 0),
state_t(spritenum_t.SPR_FATT, 11, 5, actionf_t(void, void, void), statenum_t.S_FATT_RAISE8, 0, 0),
state_t(spritenum_t.SPR_FATT, 10, 5, actionf_t(void, void, void), statenum_t.S_FATT_RUN1, 0, 0),
state_t(spritenum_t.SPR_CPOS, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_CPOS_STND2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_CPOS_STND, 0, 0),
state_t(spritenum_t.SPR_CPOS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN3, 0, 0),
state_t(spritenum_t.SPR_CPOS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN4, 0, 0),
state_t(spritenum_t.SPR_CPOS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN5, 0, 0),
state_t(spritenum_t.SPR_CPOS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN6, 0, 0),
state_t(spritenum_t.SPR_CPOS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN7, 0, 0),
state_t(spritenum_t.SPR_CPOS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN8, 0, 0),
state_t(spritenum_t.SPR_CPOS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_CPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_CPOS, 4, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_CPOS_ATK2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 32773, 4, actionf_t(A_CPosAttack, void, void), statenum_t.S_CPOS_ATK3, 0, 0),
state_t(spritenum_t.SPR_CPOS, 32772, 4, actionf_t(A_CPosAttack, void, void), statenum_t.S_CPOS_ATK4, 0, 0),
state_t(spritenum_t.SPR_CPOS, 5, 1, actionf_t(A_CPosRefire, void, void), statenum_t.S_CPOS_ATK2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 6, 3, actionf_t(void, void, void), statenum_t.S_CPOS_PAIN2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 6, 3, actionf_t(A_Pain, void, void), statenum_t.S_CPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_CPOS, 7, 5, actionf_t(void, void, void), statenum_t.S_CPOS_DIE2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 8, 5, actionf_t(A_Scream, void, void), statenum_t.S_CPOS_DIE3, 0, 0),
state_t(spritenum_t.SPR_CPOS, 9, 5, actionf_t(A_Fall, void, void), statenum_t.S_CPOS_DIE4, 0, 0),
state_t(spritenum_t.SPR_CPOS, 10, 5, actionf_t(void, void, void), statenum_t.S_CPOS_DIE5, 0, 0),
state_t(spritenum_t.SPR_CPOS, 11, 5, actionf_t(void, void, void), statenum_t.S_CPOS_DIE6, 0, 0),
state_t(spritenum_t.SPR_CPOS, 12, 5, actionf_t(void, void, void), statenum_t.S_CPOS_DIE7, 0, 0),
state_t(spritenum_t.SPR_CPOS, 13, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CPOS, 14, 5, actionf_t(void, void, void), statenum_t.S_CPOS_XDIE2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 15, 5, actionf_t(A_XScream, void, void), statenum_t.S_CPOS_XDIE3, 0, 0),
state_t(spritenum_t.SPR_CPOS, 16, 5, actionf_t(A_Fall, void, void), statenum_t.S_CPOS_XDIE4, 0, 0),
state_t(spritenum_t.SPR_CPOS, 17, 5, actionf_t(void, void, void), statenum_t.S_CPOS_XDIE5, 0, 0),
state_t(spritenum_t.SPR_CPOS, 18, 5, actionf_t(void, void, void), statenum_t.S_CPOS_XDIE6, 0, 0),
state_t(spritenum_t.SPR_CPOS, 19, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CPOS, 13, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE2, 0, 0),
state_t(spritenum_t.SPR_CPOS, 12, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE3, 0, 0),
state_t(spritenum_t.SPR_CPOS, 11, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE4, 0, 0),
state_t(spritenum_t.SPR_CPOS, 10, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE5, 0, 0),
state_t(spritenum_t.SPR_CPOS, 9, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE6, 0, 0),
state_t(spritenum_t.SPR_CPOS, 8, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RAISE7, 0, 0),
state_t(spritenum_t.SPR_CPOS, 7, 5, actionf_t(void, void, void), statenum_t.S_CPOS_RUN1, 0, 0),
state_t(spritenum_t.SPR_TROO, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_TROO_STND2, 0, 0),
state_t(spritenum_t.SPR_TROO, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_TROO_STND, 0, 0),
state_t(spritenum_t.SPR_TROO, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN2, 0, 0),
state_t(spritenum_t.SPR_TROO, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN3, 0, 0),
state_t(spritenum_t.SPR_TROO, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN4, 0, 0),
state_t(spritenum_t.SPR_TROO, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN5, 0, 0),
state_t(spritenum_t.SPR_TROO, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN6, 0, 0),
state_t(spritenum_t.SPR_TROO, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN7, 0, 0),
state_t(spritenum_t.SPR_TROO, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN8, 0, 0),
state_t(spritenum_t.SPR_TROO, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_TROO_RUN1, 0, 0),
state_t(spritenum_t.SPR_TROO, 4, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_TROO_ATK2, 0, 0),
state_t(spritenum_t.SPR_TROO, 5, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_TROO_ATK3, 0, 0),
state_t(spritenum_t.SPR_TROO, 6, 6, actionf_t(A_TroopAttack, void, void), statenum_t.S_TROO_RUN1, 0, 0),
state_t(spritenum_t.SPR_TROO, 7, 2, actionf_t(void, void, void), statenum_t.S_TROO_PAIN2, 0, 0),
state_t(spritenum_t.SPR_TROO, 7, 2, actionf_t(A_Pain, void, void), statenum_t.S_TROO_RUN1, 0, 0),
state_t(spritenum_t.SPR_TROO, 8, 8, actionf_t(void, void, void), statenum_t.S_TROO_DIE2, 0, 0),
state_t(spritenum_t.SPR_TROO, 9, 8, actionf_t(A_Scream, void, void), statenum_t.S_TROO_DIE3, 0, 0),
state_t(spritenum_t.SPR_TROO, 10, 6, actionf_t(void, void, void), statenum_t.S_TROO_DIE4, 0, 0),
state_t(spritenum_t.SPR_TROO, 11, 6, actionf_t(A_Fall, void, void), statenum_t.S_TROO_DIE5, 0, 0),
state_t(spritenum_t.SPR_TROO, 12, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TROO, 13, 5, actionf_t(void, void, void), statenum_t.S_TROO_XDIE2, 0, 0),
state_t(spritenum_t.SPR_TROO, 14, 5, actionf_t(A_XScream, void, void), statenum_t.S_TROO_XDIE3, 0, 0),
state_t(spritenum_t.SPR_TROO, 15, 5, actionf_t(void, void, void), statenum_t.S_TROO_XDIE4, 0, 0),
state_t(spritenum_t.SPR_TROO, 16, 5, actionf_t(A_Fall, void, void), statenum_t.S_TROO_XDIE5, 0, 0),
state_t(spritenum_t.SPR_TROO, 17, 5, actionf_t(void, void, void), statenum_t.S_TROO_XDIE6, 0, 0),
state_t(spritenum_t.SPR_TROO, 18, 5, actionf_t(void, void, void), statenum_t.S_TROO_XDIE7, 0, 0),
state_t(spritenum_t.SPR_TROO, 19, 5, actionf_t(void, void, void), statenum_t.S_TROO_XDIE8, 0, 0),
state_t(spritenum_t.SPR_TROO, 20, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TROO, 12, 8, actionf_t(void, void, void), statenum_t.S_TROO_RAISE2, 0, 0),
state_t(spritenum_t.SPR_TROO, 11, 8, actionf_t(void, void, void), statenum_t.S_TROO_RAISE3, 0, 0),
state_t(spritenum_t.SPR_TROO, 10, 6, actionf_t(void, void, void), statenum_t.S_TROO_RAISE4, 0, 0),
state_t(spritenum_t.SPR_TROO, 9, 6, actionf_t(void, void, void), statenum_t.S_TROO_RAISE5, 0, 0),
state_t(spritenum_t.SPR_TROO, 8, 6, actionf_t(void, void, void), statenum_t.S_TROO_RUN1, 0, 0),
state_t(spritenum_t.SPR_SARG, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_SARG_STND2, 0, 0),
state_t(spritenum_t.SPR_SARG, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_SARG_STND, 0, 0),
state_t(spritenum_t.SPR_SARG, 0, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN2, 0, 0),
state_t(spritenum_t.SPR_SARG, 0, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN3, 0, 0),
state_t(spritenum_t.SPR_SARG, 1, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN4, 0, 0),
state_t(spritenum_t.SPR_SARG, 1, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN5, 0, 0),
state_t(spritenum_t.SPR_SARG, 2, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN6, 0, 0),
state_t(spritenum_t.SPR_SARG, 2, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN7, 0, 0),
state_t(spritenum_t.SPR_SARG, 3, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN8, 0, 0),
state_t(spritenum_t.SPR_SARG, 3, 2, actionf_t(A_Chase, void, void), statenum_t.S_SARG_RUN1, 0, 0),
state_t(spritenum_t.SPR_SARG, 4, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_SARG_ATK2, 0, 0),
state_t(spritenum_t.SPR_SARG, 5, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_SARG_ATK3, 0, 0),
state_t(spritenum_t.SPR_SARG, 6, 8, actionf_t(A_SargAttack, void, void), statenum_t.S_SARG_RUN1, 0, 0),
state_t(spritenum_t.SPR_SARG, 7, 2, actionf_t(void, void, void), statenum_t.S_SARG_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SARG, 7, 2, actionf_t(A_Pain, void, void), statenum_t.S_SARG_RUN1, 0, 0),
state_t(spritenum_t.SPR_SARG, 8, 8, actionf_t(void, void, void), statenum_t.S_SARG_DIE2, 0, 0),
state_t(spritenum_t.SPR_SARG, 9, 8, actionf_t(A_Scream, void, void), statenum_t.S_SARG_DIE3, 0, 0),
state_t(spritenum_t.SPR_SARG, 10, 4, actionf_t(void, void, void), statenum_t.S_SARG_DIE4, 0, 0),
state_t(spritenum_t.SPR_SARG, 11, 4, actionf_t(A_Fall, void, void), statenum_t.S_SARG_DIE5, 0, 0),
state_t(spritenum_t.SPR_SARG, 12, 4, actionf_t(void, void, void), statenum_t.S_SARG_DIE6, 0, 0),
state_t(spritenum_t.SPR_SARG, 13, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SARG, 13, 5, actionf_t(void, void, void), statenum_t.S_SARG_RAISE2, 0, 0),
state_t(spritenum_t.SPR_SARG, 12, 5, actionf_t(void, void, void), statenum_t.S_SARG_RAISE3, 0, 0),
state_t(spritenum_t.SPR_SARG, 11, 5, actionf_t(void, void, void), statenum_t.S_SARG_RAISE4, 0, 0),
state_t(spritenum_t.SPR_SARG, 10, 5, actionf_t(void, void, void), statenum_t.S_SARG_RAISE5, 0, 0),
state_t(spritenum_t.SPR_SARG, 9, 5, actionf_t(void, void, void), statenum_t.S_SARG_RAISE6, 0, 0),
state_t(spritenum_t.SPR_SARG, 8, 5, actionf_t(void, void, void), statenum_t.S_SARG_RUN1, 0, 0),
state_t(spritenum_t.SPR_HEAD, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_HEAD_STND, 0, 0),
state_t(spritenum_t.SPR_HEAD, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_HEAD_RUN1, 0, 0),
state_t(spritenum_t.SPR_HEAD, 1, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_HEAD_ATK2, 0, 0),
state_t(spritenum_t.SPR_HEAD, 2, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_HEAD_ATK3, 0, 0),
state_t(spritenum_t.SPR_HEAD, 32771, 5, actionf_t(A_HeadAttack, void, void), statenum_t.S_HEAD_RUN1, 0, 0),
state_t(spritenum_t.SPR_HEAD, 4, 3, actionf_t(void, void, void), statenum_t.S_HEAD_PAIN2, 0, 0),
state_t(spritenum_t.SPR_HEAD, 4, 3, actionf_t(A_Pain, void, void), statenum_t.S_HEAD_PAIN3, 0, 0),
state_t(spritenum_t.SPR_HEAD, 5, 6, actionf_t(void, void, void), statenum_t.S_HEAD_RUN1, 0, 0),
state_t(spritenum_t.SPR_HEAD, 6, 8, actionf_t(void, void, void), statenum_t.S_HEAD_DIE2, 0, 0),
state_t(spritenum_t.SPR_HEAD, 7, 8, actionf_t(A_Scream, void, void), statenum_t.S_HEAD_DIE3, 0, 0),
state_t(spritenum_t.SPR_HEAD, 8, 8, actionf_t(void, void, void), statenum_t.S_HEAD_DIE4, 0, 0),
state_t(spritenum_t.SPR_HEAD, 9, 8, actionf_t(void, void, void), statenum_t.S_HEAD_DIE5, 0, 0),
state_t(spritenum_t.SPR_HEAD, 10, 8, actionf_t(A_Fall, void, void), statenum_t.S_HEAD_DIE6, 0, 0),
state_t(spritenum_t.SPR_HEAD, 11, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HEAD, 11, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RAISE2, 0, 0),
state_t(spritenum_t.SPR_HEAD, 10, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RAISE3, 0, 0),
state_t(spritenum_t.SPR_HEAD, 9, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RAISE4, 0, 0),
state_t(spritenum_t.SPR_HEAD, 8, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RAISE5, 0, 0),
state_t(spritenum_t.SPR_HEAD, 7, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RAISE6, 0, 0),
state_t(spritenum_t.SPR_HEAD, 6, 8, actionf_t(void, void, void), statenum_t.S_HEAD_RUN1, 0, 0),
state_t(spritenum_t.SPR_BAL7, 32768, 4, actionf_t(void, void, void), statenum_t.S_BRBALL2, 0, 0),
state_t(spritenum_t.SPR_BAL7, 32769, 4, actionf_t(void, void, void), statenum_t.S_BRBALL1, 0, 0),
state_t(spritenum_t.SPR_BAL7, 32770, 6, actionf_t(void, void, void), statenum_t.S_BRBALLX2, 0, 0),
state_t(spritenum_t.SPR_BAL7, 32771, 6, actionf_t(void, void, void), statenum_t.S_BRBALLX3, 0, 0),
state_t(spritenum_t.SPR_BAL7, 32772, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BOSS, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_BOSS_STND2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_BOSS_STND, 0, 0),
state_t(spritenum_t.SPR_BOSS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN3, 0, 0),
state_t(spritenum_t.SPR_BOSS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN4, 0, 0),
state_t(spritenum_t.SPR_BOSS, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN5, 0, 0),
state_t(spritenum_t.SPR_BOSS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN6, 0, 0),
state_t(spritenum_t.SPR_BOSS, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN7, 0, 0),
state_t(spritenum_t.SPR_BOSS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN8, 0, 0),
state_t(spritenum_t.SPR_BOSS, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOSS, 4, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_BOSS_ATK2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 5, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_BOSS_ATK3, 0, 0),
state_t(spritenum_t.SPR_BOSS, 6, 8, actionf_t(A_BruisAttack, void, void), statenum_t.S_BOSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOSS, 7, 2, actionf_t(void, void, void), statenum_t.S_BOSS_PAIN2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 7, 2, actionf_t(A_Pain, void, void), statenum_t.S_BOSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOSS, 8, 8, actionf_t(void, void, void), statenum_t.S_BOSS_DIE2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 9, 8, actionf_t(A_Scream, void, void), statenum_t.S_BOSS_DIE3, 0, 0),
state_t(spritenum_t.SPR_BOSS, 10, 8, actionf_t(void, void, void), statenum_t.S_BOSS_DIE4, 0, 0),
state_t(spritenum_t.SPR_BOSS, 11, 8, actionf_t(A_Fall, void, void), statenum_t.S_BOSS_DIE5, 0, 0),
state_t(spritenum_t.SPR_BOSS, 12, 8, actionf_t(void, void, void), statenum_t.S_BOSS_DIE6, 0, 0),
state_t(spritenum_t.SPR_BOSS, 13, 8, actionf_t(void, void, void), statenum_t.S_BOSS_DIE7, 0, 0),
state_t(spritenum_t.SPR_BOSS, 14, -1, actionf_t(A_BossDeath, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BOSS, 14, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE2, 0, 0),
state_t(spritenum_t.SPR_BOSS, 13, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE3, 0, 0),
state_t(spritenum_t.SPR_BOSS, 12, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE4, 0, 0),
state_t(spritenum_t.SPR_BOSS, 11, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE5, 0, 0),
state_t(spritenum_t.SPR_BOSS, 10, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE6, 0, 0),
state_t(spritenum_t.SPR_BOSS, 9, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RAISE7, 0, 0),
state_t(spritenum_t.SPR_BOSS, 8, 8, actionf_t(void, void, void), statenum_t.S_BOSS_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOS2, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_BOS2_STND2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_BOS2_STND, 0, 0),
state_t(spritenum_t.SPR_BOS2, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN3, 0, 0),
state_t(spritenum_t.SPR_BOS2, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN4, 0, 0),
state_t(spritenum_t.SPR_BOS2, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN5, 0, 0),
state_t(spritenum_t.SPR_BOS2, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN6, 0, 0),
state_t(spritenum_t.SPR_BOS2, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN7, 0, 0),
state_t(spritenum_t.SPR_BOS2, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN8, 0, 0),
state_t(spritenum_t.SPR_BOS2, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_BOS2_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOS2, 4, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_BOS2_ATK2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 5, 8, actionf_t(A_FaceTarget, void, void), statenum_t.S_BOS2_ATK3, 0, 0),
state_t(spritenum_t.SPR_BOS2, 6, 8, actionf_t(A_BruisAttack, void, void), statenum_t.S_BOS2_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOS2, 7, 2, actionf_t(void, void, void), statenum_t.S_BOS2_PAIN2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 7, 2, actionf_t(A_Pain, void, void), statenum_t.S_BOS2_RUN1, 0, 0),
state_t(spritenum_t.SPR_BOS2, 8, 8, actionf_t(void, void, void), statenum_t.S_BOS2_DIE2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 9, 8, actionf_t(A_Scream, void, void), statenum_t.S_BOS2_DIE3, 0, 0),
state_t(spritenum_t.SPR_BOS2, 10, 8, actionf_t(void, void, void), statenum_t.S_BOS2_DIE4, 0, 0),
state_t(spritenum_t.SPR_BOS2, 11, 8, actionf_t(A_Fall, void, void), statenum_t.S_BOS2_DIE5, 0, 0),
state_t(spritenum_t.SPR_BOS2, 12, 8, actionf_t(void, void, void), statenum_t.S_BOS2_DIE6, 0, 0),
state_t(spritenum_t.SPR_BOS2, 13, 8, actionf_t(void, void, void), statenum_t.S_BOS2_DIE7, 0, 0),
state_t(spritenum_t.SPR_BOS2, 14, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BOS2, 14, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE2, 0, 0),
state_t(spritenum_t.SPR_BOS2, 13, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE3, 0, 0),
state_t(spritenum_t.SPR_BOS2, 12, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE4, 0, 0),
state_t(spritenum_t.SPR_BOS2, 11, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE5, 0, 0),
state_t(spritenum_t.SPR_BOS2, 10, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE6, 0, 0),
state_t(spritenum_t.SPR_BOS2, 9, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RAISE7, 0, 0),
state_t(spritenum_t.SPR_BOS2, 8, 8, actionf_t(void, void, void), statenum_t.S_BOS2_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32768, 10, actionf_t(A_Look, void, void), statenum_t.S_SKULL_STND2, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32769, 10, actionf_t(A_Look, void, void), statenum_t.S_SKULL_STND, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32768, 6, actionf_t(A_Chase, void, void), statenum_t.S_SKULL_RUN2, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32769, 6, actionf_t(A_Chase, void, void), statenum_t.S_SKULL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32770, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SKULL_ATK2, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32771, 4, actionf_t(A_SkullAttack, void, void), statenum_t.S_SKULL_ATK3, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32770, 4, actionf_t(void, void, void), statenum_t.S_SKULL_ATK4, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32771, 4, actionf_t(void, void, void), statenum_t.S_SKULL_ATK3, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32772, 3, actionf_t(void, void, void), statenum_t.S_SKULL_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32772, 3, actionf_t(A_Pain, void, void), statenum_t.S_SKULL_RUN1, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32773, 6, actionf_t(void, void, void), statenum_t.S_SKULL_DIE2, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32774, 6, actionf_t(A_Scream, void, void), statenum_t.S_SKULL_DIE3, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32775, 6, actionf_t(void, void, void), statenum_t.S_SKULL_DIE4, 0, 0),
state_t(spritenum_t.SPR_SKUL, 32776, 6, actionf_t(A_Fall, void, void), statenum_t.S_SKULL_DIE5, 0, 0),
state_t(spritenum_t.SPR_SKUL, 9, 6, actionf_t(void, void, void), statenum_t.S_SKULL_DIE6, 0, 0),
state_t(spritenum_t.SPR_SKUL, 10, 6, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SPID, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_SPID_STND2, 0, 0),
state_t(spritenum_t.SPR_SPID, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_SPID_STND, 0, 0),
state_t(spritenum_t.SPR_SPID, 0, 3, actionf_t(A_Metal, void, void), statenum_t.S_SPID_RUN2, 0, 0),
state_t(spritenum_t.SPR_SPID, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN3, 0, 0),
state_t(spritenum_t.SPR_SPID, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN4, 0, 0),
state_t(spritenum_t.SPR_SPID, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN5, 0, 0),
state_t(spritenum_t.SPR_SPID, 2, 3, actionf_t(A_Metal, void, void), statenum_t.S_SPID_RUN6, 0, 0),
state_t(spritenum_t.SPR_SPID, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN7, 0, 0),
state_t(spritenum_t.SPR_SPID, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN8, 0, 0),
state_t(spritenum_t.SPR_SPID, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN9, 0, 0),
state_t(spritenum_t.SPR_SPID, 4, 3, actionf_t(A_Metal, void, void), statenum_t.S_SPID_RUN10, 0, 0),
state_t(spritenum_t.SPR_SPID, 4, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN11, 0, 0),
state_t(spritenum_t.SPR_SPID, 5, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN12, 0, 0),
state_t(spritenum_t.SPR_SPID, 5, 3, actionf_t(A_Chase, void, void), statenum_t.S_SPID_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPID, 32768, 20, actionf_t(A_FaceTarget, void, void), statenum_t.S_SPID_ATK2, 0, 0),
state_t(spritenum_t.SPR_SPID, 32774, 4, actionf_t(A_SPosAttack, void, void), statenum_t.S_SPID_ATK3, 0, 0),
state_t(spritenum_t.SPR_SPID, 32775, 4, actionf_t(A_SPosAttack, void, void), statenum_t.S_SPID_ATK4, 0, 0),
state_t(spritenum_t.SPR_SPID, 32775, 1, actionf_t(A_SpidRefire, void, void), statenum_t.S_SPID_ATK2, 0, 0),
state_t(spritenum_t.SPR_SPID, 8, 3, actionf_t(void, void, void), statenum_t.S_SPID_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SPID, 8, 3, actionf_t(A_Pain, void, void), statenum_t.S_SPID_RUN1, 0, 0),
state_t(spritenum_t.SPR_SPID, 9, 20, actionf_t(A_Scream, void, void), statenum_t.S_SPID_DIE2, 0, 0),
state_t(spritenum_t.SPR_SPID, 10, 10, actionf_t(A_Fall, void, void), statenum_t.S_SPID_DIE3, 0, 0),
state_t(spritenum_t.SPR_SPID, 11, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE4, 0, 0),
state_t(spritenum_t.SPR_SPID, 12, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE5, 0, 0),
state_t(spritenum_t.SPR_SPID, 13, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE6, 0, 0),
state_t(spritenum_t.SPR_SPID, 14, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE7, 0, 0),
state_t(spritenum_t.SPR_SPID, 15, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE8, 0, 0),
state_t(spritenum_t.SPR_SPID, 16, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE9, 0, 0),
state_t(spritenum_t.SPR_SPID, 17, 10, actionf_t(void, void, void), statenum_t.S_SPID_DIE10, 0, 0),
state_t(spritenum_t.SPR_SPID, 18, 30, actionf_t(void, void, void), statenum_t.S_SPID_DIE11, 0, 0),
state_t(spritenum_t.SPR_SPID, 18, -1, actionf_t(A_BossDeath, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BSPI, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_BSPI_STND2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_BSPI_STND, 0, 0),
state_t(spritenum_t.SPR_BSPI, 0, 20, actionf_t(void, void, void), statenum_t.S_BSPI_RUN1, 0, 0),
state_t(spritenum_t.SPR_BSPI, 0, 3, actionf_t(A_BabyMetal, void, void), statenum_t.S_BSPI_RUN2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN3, 0, 0),
state_t(spritenum_t.SPR_BSPI, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN4, 0, 0),
state_t(spritenum_t.SPR_BSPI, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN5, 0, 0),
state_t(spritenum_t.SPR_BSPI, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN6, 0, 0),
state_t(spritenum_t.SPR_BSPI, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN7, 0, 0),
state_t(spritenum_t.SPR_BSPI, 3, 3, actionf_t(A_BabyMetal, void, void), statenum_t.S_BSPI_RUN8, 0, 0),
state_t(spritenum_t.SPR_BSPI, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN9, 0, 0),
state_t(spritenum_t.SPR_BSPI, 4, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN10, 0, 0),
state_t(spritenum_t.SPR_BSPI, 4, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN11, 0, 0),
state_t(spritenum_t.SPR_BSPI, 5, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN12, 0, 0),
state_t(spritenum_t.SPR_BSPI, 5, 3, actionf_t(A_Chase, void, void), statenum_t.S_BSPI_RUN1, 0, 0),
state_t(spritenum_t.SPR_BSPI, 32768, 20, actionf_t(A_FaceTarget, void, void), statenum_t.S_BSPI_ATK2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 32774, 4, actionf_t(A_BspiAttack, void, void), statenum_t.S_BSPI_ATK3, 0, 0),
state_t(spritenum_t.SPR_BSPI, 32775, 4, actionf_t(void, void, void), statenum_t.S_BSPI_ATK4, 0, 0),
state_t(spritenum_t.SPR_BSPI, 32775, 1, actionf_t(A_SpidRefire, void, void), statenum_t.S_BSPI_ATK2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 8, 3, actionf_t(void, void, void), statenum_t.S_BSPI_PAIN2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 8, 3, actionf_t(A_Pain, void, void), statenum_t.S_BSPI_RUN1, 0, 0),
state_t(spritenum_t.SPR_BSPI, 9, 20, actionf_t(A_Scream, void, void), statenum_t.S_BSPI_DIE2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 10, 7, actionf_t(A_Fall, void, void), statenum_t.S_BSPI_DIE3, 0, 0),
state_t(spritenum_t.SPR_BSPI, 11, 7, actionf_t(void, void, void), statenum_t.S_BSPI_DIE4, 0, 0),
state_t(spritenum_t.SPR_BSPI, 12, 7, actionf_t(void, void, void), statenum_t.S_BSPI_DIE5, 0, 0),
state_t(spritenum_t.SPR_BSPI, 13, 7, actionf_t(void, void, void), statenum_t.S_BSPI_DIE6, 0, 0),
state_t(spritenum_t.SPR_BSPI, 14, 7, actionf_t(void, void, void), statenum_t.S_BSPI_DIE7, 0, 0),
state_t(spritenum_t.SPR_BSPI, 15, -1, actionf_t(A_BossDeath, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BSPI, 15, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE2, 0, 0),
state_t(spritenum_t.SPR_BSPI, 14, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE3, 0, 0),
state_t(spritenum_t.SPR_BSPI, 13, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE4, 0, 0),
state_t(spritenum_t.SPR_BSPI, 12, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE5, 0, 0),
state_t(spritenum_t.SPR_BSPI, 11, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE6, 0, 0),
state_t(spritenum_t.SPR_BSPI, 10, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RAISE7, 0, 0),
state_t(spritenum_t.SPR_BSPI, 9, 5, actionf_t(void, void, void), statenum_t.S_BSPI_RUN1, 0, 0),
state_t(spritenum_t.SPR_APLS, 32768, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLAZ2, 0, 0),
state_t(spritenum_t.SPR_APLS, 32769, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLAZ, 0, 0),
state_t(spritenum_t.SPR_APBX, 32768, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLEX2, 0, 0),
state_t(spritenum_t.SPR_APBX, 32769, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLEX3, 0, 0),
state_t(spritenum_t.SPR_APBX, 32770, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLEX4, 0, 0),
state_t(spritenum_t.SPR_APBX, 32771, 5, actionf_t(void, void, void), statenum_t.S_ARACH_PLEX5, 0, 0),
state_t(spritenum_t.SPR_APBX, 32772, 5, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CYBR, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_CYBER_STND2, 0, 0),
state_t(spritenum_t.SPR_CYBR, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_CYBER_STND, 0, 0),
state_t(spritenum_t.SPR_CYBR, 0, 3, actionf_t(A_Hoof, void, void), statenum_t.S_CYBER_RUN2, 0, 0),
state_t(spritenum_t.SPR_CYBR, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN3, 0, 0),
state_t(spritenum_t.SPR_CYBR, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN4, 0, 0),
state_t(spritenum_t.SPR_CYBR, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN5, 0, 0),
state_t(spritenum_t.SPR_CYBR, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN6, 0, 0),
state_t(spritenum_t.SPR_CYBR, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN7, 0, 0),
state_t(spritenum_t.SPR_CYBR, 3, 3, actionf_t(A_Metal, void, void), statenum_t.S_CYBER_RUN8, 0, 0),
state_t(spritenum_t.SPR_CYBR, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_CYBER_RUN1, 0, 0),
state_t(spritenum_t.SPR_CYBR, 4, 6, actionf_t(A_FaceTarget, void, void), statenum_t.S_CYBER_ATK2, 0, 0),
state_t(spritenum_t.SPR_CYBR, 5, 12, actionf_t(A_CyberAttack, void, void), statenum_t.S_CYBER_ATK3, 0, 0),
state_t(spritenum_t.SPR_CYBR, 4, 12, actionf_t(A_FaceTarget, void, void), statenum_t.S_CYBER_ATK4, 0, 0),
state_t(spritenum_t.SPR_CYBR, 5, 12, actionf_t(A_CyberAttack, void, void), statenum_t.S_CYBER_ATK5, 0, 0),
state_t(spritenum_t.SPR_CYBR, 4, 12, actionf_t(A_FaceTarget, void, void), statenum_t.S_CYBER_ATK6, 0, 0),
state_t(spritenum_t.SPR_CYBR, 5, 12, actionf_t(A_CyberAttack, void, void), statenum_t.S_CYBER_RUN1, 0, 0),
state_t(spritenum_t.SPR_CYBR, 6, 10, actionf_t(A_Pain, void, void), statenum_t.S_CYBER_RUN1, 0, 0),
state_t(spritenum_t.SPR_CYBR, 7, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE2, 0, 0),
state_t(spritenum_t.SPR_CYBR, 8, 10, actionf_t(A_Scream, void, void), statenum_t.S_CYBER_DIE3, 0, 0),
state_t(spritenum_t.SPR_CYBR, 9, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE4, 0, 0),
state_t(spritenum_t.SPR_CYBR, 10, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE5, 0, 0),
state_t(spritenum_t.SPR_CYBR, 11, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE6, 0, 0),
state_t(spritenum_t.SPR_CYBR, 12, 10, actionf_t(A_Fall, void, void), statenum_t.S_CYBER_DIE7, 0, 0),
state_t(spritenum_t.SPR_CYBR, 13, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE8, 0, 0),
state_t(spritenum_t.SPR_CYBR, 14, 10, actionf_t(void, void, void), statenum_t.S_CYBER_DIE9, 0, 0),
state_t(spritenum_t.SPR_CYBR, 15, 30, actionf_t(void, void, void), statenum_t.S_CYBER_DIE10, 0, 0),
state_t(spritenum_t.SPR_CYBR, 15, -1, actionf_t(A_BossDeath, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PAIN, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_PAIN_STND, 0, 0),
state_t(spritenum_t.SPR_PAIN, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN2, 0, 0),
state_t(spritenum_t.SPR_PAIN, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN3, 0, 0),
state_t(spritenum_t.SPR_PAIN, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN4, 0, 0),
state_t(spritenum_t.SPR_PAIN, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN5, 0, 0),
state_t(spritenum_t.SPR_PAIN, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN6, 0, 0),
state_t(spritenum_t.SPR_PAIN, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_PAIN_RUN1, 0, 0),
state_t(spritenum_t.SPR_PAIN, 3, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_PAIN_ATK2, 0, 0),
state_t(spritenum_t.SPR_PAIN, 4, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_PAIN_ATK3, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32773, 5, actionf_t(A_FaceTarget, void, void), statenum_t.S_PAIN_ATK4, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32773, 0, actionf_t(A_PainAttack, void, void), statenum_t.S_PAIN_RUN1, 0, 0),
state_t(spritenum_t.SPR_PAIN, 6, 6, actionf_t(void, void, void), statenum_t.S_PAIN_PAIN2, 0, 0),
state_t(spritenum_t.SPR_PAIN, 6, 6, actionf_t(A_Pain, void, void), statenum_t.S_PAIN_RUN1, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32775, 8, actionf_t(void, void, void), statenum_t.S_PAIN_DIE2, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32776, 8, actionf_t(A_Scream, void, void), statenum_t.S_PAIN_DIE3, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32777, 8, actionf_t(void, void, void), statenum_t.S_PAIN_DIE4, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32778, 8, actionf_t(void, void, void), statenum_t.S_PAIN_DIE5, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32779, 8, actionf_t(A_PainDie, void, void), statenum_t.S_PAIN_DIE6, 0, 0),
state_t(spritenum_t.SPR_PAIN, 32780, 8, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PAIN, 12, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RAISE2, 0, 0),
state_t(spritenum_t.SPR_PAIN, 11, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RAISE3, 0, 0),
state_t(spritenum_t.SPR_PAIN, 10, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RAISE4, 0, 0),
state_t(spritenum_t.SPR_PAIN, 9, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RAISE5, 0, 0),
state_t(spritenum_t.SPR_PAIN, 8, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RAISE6, 0, 0),
state_t(spritenum_t.SPR_PAIN, 7, 8, actionf_t(void, void, void), statenum_t.S_PAIN_RUN1, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_SSWV_STND2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 1, 10, actionf_t(A_Look, void, void), statenum_t.S_SSWV_STND, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN3, 0, 0),
state_t(spritenum_t.SPR_SSWV, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN4, 0, 0),
state_t(spritenum_t.SPR_SSWV, 1, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN5, 0, 0),
state_t(spritenum_t.SPR_SSWV, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN6, 0, 0),
state_t(spritenum_t.SPR_SSWV, 2, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN7, 0, 0),
state_t(spritenum_t.SPR_SSWV, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN8, 0, 0),
state_t(spritenum_t.SPR_SSWV, 3, 3, actionf_t(A_Chase, void, void), statenum_t.S_SSWV_RUN1, 0, 0),
state_t(spritenum_t.SPR_SSWV, 4, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SSWV_ATK2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 5, 10, actionf_t(A_FaceTarget, void, void), statenum_t.S_SSWV_ATK3, 0, 0),
state_t(spritenum_t.SPR_SSWV, 32774, 4, actionf_t(A_CPosAttack, void, void), statenum_t.S_SSWV_ATK4, 0, 0),
state_t(spritenum_t.SPR_SSWV, 5, 6, actionf_t(A_FaceTarget, void, void), statenum_t.S_SSWV_ATK5, 0, 0),
state_t(spritenum_t.SPR_SSWV, 32774, 4, actionf_t(A_CPosAttack, void, void), statenum_t.S_SSWV_ATK6, 0, 0),
state_t(spritenum_t.SPR_SSWV, 5, 1, actionf_t(A_CPosRefire, void, void), statenum_t.S_SSWV_ATK2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 7, 3, actionf_t(void, void, void), statenum_t.S_SSWV_PAIN2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 7, 3, actionf_t(A_Pain, void, void), statenum_t.S_SSWV_RUN1, 0, 0),
state_t(spritenum_t.SPR_SSWV, 8, 5, actionf_t(void, void, void), statenum_t.S_SSWV_DIE2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 9, 5, actionf_t(A_Scream, void, void), statenum_t.S_SSWV_DIE3, 0, 0),
state_t(spritenum_t.SPR_SSWV, 10, 5, actionf_t(A_Fall, void, void), statenum_t.S_SSWV_DIE4, 0, 0),
state_t(spritenum_t.SPR_SSWV, 11, 5, actionf_t(void, void, void), statenum_t.S_SSWV_DIE5, 0, 0),
state_t(spritenum_t.SPR_SSWV, 12, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SSWV, 13, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 14, 5, actionf_t(A_XScream, void, void), statenum_t.S_SSWV_XDIE3, 0, 0),
state_t(spritenum_t.SPR_SSWV, 15, 5, actionf_t(A_Fall, void, void), statenum_t.S_SSWV_XDIE4, 0, 0),
state_t(spritenum_t.SPR_SSWV, 16, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE5, 0, 0),
state_t(spritenum_t.SPR_SSWV, 17, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE6, 0, 0),
state_t(spritenum_t.SPR_SSWV, 18, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE7, 0, 0),
state_t(spritenum_t.SPR_SSWV, 19, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE8, 0, 0),
state_t(spritenum_t.SPR_SSWV, 20, 5, actionf_t(void, void, void), statenum_t.S_SSWV_XDIE9, 0, 0),
state_t(spritenum_t.SPR_SSWV, 21, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SSWV, 12, 5, actionf_t(void, void, void), statenum_t.S_SSWV_RAISE2, 0, 0),
state_t(spritenum_t.SPR_SSWV, 11, 5, actionf_t(void, void, void), statenum_t.S_SSWV_RAISE3, 0, 0),
state_t(spritenum_t.SPR_SSWV, 10, 5, actionf_t(void, void, void), statenum_t.S_SSWV_RAISE4, 0, 0),
state_t(spritenum_t.SPR_SSWV, 9, 5, actionf_t(void, void, void), statenum_t.S_SSWV_RAISE5, 0, 0),
state_t(spritenum_t.SPR_SSWV, 8, 5, actionf_t(void, void, void), statenum_t.S_SSWV_RUN1, 0, 0),
state_t(spritenum_t.SPR_KEEN, 0, -1, actionf_t(void, void, void), statenum_t.S_KEENSTND, 0, 0),
state_t(spritenum_t.SPR_KEEN, 0, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN2, 0, 0),
state_t(spritenum_t.SPR_KEEN, 1, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN3, 0, 0),
state_t(spritenum_t.SPR_KEEN, 2, 6, actionf_t(A_Scream, void, void), statenum_t.S_COMMKEEN4, 0, 0),
state_t(spritenum_t.SPR_KEEN, 3, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN5, 0, 0),
state_t(spritenum_t.SPR_KEEN, 4, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN6, 0, 0),
state_t(spritenum_t.SPR_KEEN, 5, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN7, 0, 0),
state_t(spritenum_t.SPR_KEEN, 6, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN8, 0, 0),
state_t(spritenum_t.SPR_KEEN, 7, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN9, 0, 0),
state_t(spritenum_t.SPR_KEEN, 8, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN10, 0, 0),
state_t(spritenum_t.SPR_KEEN, 9, 6, actionf_t(void, void, void), statenum_t.S_COMMKEEN11, 0, 0),
state_t(spritenum_t.SPR_KEEN, 10, 6, actionf_t(A_KeenDie, void, void), statenum_t.S_COMMKEEN12, 0, 0),
state_t(spritenum_t.SPR_KEEN, 11, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_KEEN, 12, 4, actionf_t(void, void, void), statenum_t.S_KEENPAIN2, 0, 0),
state_t(spritenum_t.SPR_KEEN, 12, 8, actionf_t(A_Pain, void, void), statenum_t.S_KEENSTND, 0, 0),
state_t(spritenum_t.SPR_BBRN, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BBRN, 1, 36, actionf_t(A_BrainPain, void, void), statenum_t.S_BRAIN, 0, 0),
state_t(spritenum_t.SPR_BBRN, 0, 100, actionf_t(A_BrainScream, void, void), statenum_t.S_BRAIN_DIE2, 0, 0),
state_t(spritenum_t.SPR_BBRN, 0, 10, actionf_t(void, void, void), statenum_t.S_BRAIN_DIE3, 0, 0),
state_t(spritenum_t.SPR_BBRN, 0, 10, actionf_t(void, void, void), statenum_t.S_BRAIN_DIE4, 0, 0),
state_t(spritenum_t.SPR_BBRN, 0, -1, actionf_t(A_BrainDie, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 10, actionf_t(A_Look, void, void), statenum_t.S_BRAINEYE, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 181, actionf_t(A_BrainAwake, void, void), statenum_t.S_BRAINEYE1, 0, 0),
state_t(spritenum_t.SPR_SSWV, 0, 150, actionf_t(A_BrainSpit, void, void), statenum_t.S_BRAINEYE1, 0, 0),
state_t(spritenum_t.SPR_BOSF, 32768, 3, actionf_t(A_SpawnSound, void, void), statenum_t.S_SPAWN2, 0, 0),
state_t(spritenum_t.SPR_BOSF, 32769, 3, actionf_t(A_SpawnFly, void, void), statenum_t.S_SPAWN3, 0, 0),
state_t(spritenum_t.SPR_BOSF, 32770, 3, actionf_t(A_SpawnFly, void, void), statenum_t.S_SPAWN4, 0, 0),
state_t(spritenum_t.SPR_BOSF, 32771, 3, actionf_t(A_SpawnFly, void, void), statenum_t.S_SPAWN1, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32768, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE2, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32769, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE3, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32770, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE4, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32771, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE5, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32772, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE6, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32773, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE7, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32774, 4, actionf_t(A_Fire, void, void), statenum_t.S_SPAWNFIRE8, 0, 0),
state_t(spritenum_t.SPR_FIRE, 32775, 4, actionf_t(A_Fire, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_MISL, 32769, 10, actionf_t(void, void, void), statenum_t.S_BRAINEXPLODE2, 0, 0),
state_t(spritenum_t.SPR_MISL, 32770, 10, actionf_t(void, void, void), statenum_t.S_BRAINEXPLODE3, 0, 0),
state_t(spritenum_t.SPR_MISL, 32771, 10, actionf_t(A_BrainExplode, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_ARM1, 0, 6, actionf_t(void, void, void), statenum_t.S_ARM1A, 0, 0),
state_t(spritenum_t.SPR_ARM1, 32769, 7, actionf_t(void, void, void), statenum_t.S_ARM1, 0, 0),
state_t(spritenum_t.SPR_ARM2, 0, 6, actionf_t(void, void, void), statenum_t.S_ARM2A, 0, 0),
state_t(spritenum_t.SPR_ARM2, 32769, 6, actionf_t(void, void, void), statenum_t.S_ARM2, 0, 0),
state_t(spritenum_t.SPR_BAR1, 0, 6, actionf_t(void, void, void), statenum_t.S_BAR2, 0, 0),
state_t(spritenum_t.SPR_BAR1, 1, 6, actionf_t(void, void, void), statenum_t.S_BAR1, 0, 0),
state_t(spritenum_t.SPR_BEXP, 32768, 5, actionf_t(void, void, void), statenum_t.S_BEXP2, 0, 0),
state_t(spritenum_t.SPR_BEXP, 32769, 5, actionf_t(A_Scream, void, void), statenum_t.S_BEXP3, 0, 0),
state_t(spritenum_t.SPR_BEXP, 32770, 5, actionf_t(void, void, void), statenum_t.S_BEXP4, 0, 0),
state_t(spritenum_t.SPR_BEXP, 32771, 10, actionf_t(A_Explode, void, void), statenum_t.S_BEXP5, 0, 0),
state_t(spritenum_t.SPR_BEXP, 32772, 10, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_FCAN, 32768, 4, actionf_t(void, void, void), statenum_t.S_BBAR2, 0, 0),
state_t(spritenum_t.SPR_FCAN, 32769, 4, actionf_t(void, void, void), statenum_t.S_BBAR3, 0, 0),
state_t(spritenum_t.SPR_FCAN, 32770, 4, actionf_t(void, void, void), statenum_t.S_BBAR1, 0, 0),
state_t(spritenum_t.SPR_BON1, 0, 6, actionf_t(void, void, void), statenum_t.S_BON1A, 0, 0),
state_t(spritenum_t.SPR_BON1, 1, 6, actionf_t(void, void, void), statenum_t.S_BON1B, 0, 0),
state_t(spritenum_t.SPR_BON1, 2, 6, actionf_t(void, void, void), statenum_t.S_BON1C, 0, 0),
state_t(spritenum_t.SPR_BON1, 3, 6, actionf_t(void, void, void), statenum_t.S_BON1D, 0, 0),
state_t(spritenum_t.SPR_BON1, 2, 6, actionf_t(void, void, void), statenum_t.S_BON1E, 0, 0),
state_t(spritenum_t.SPR_BON1, 1, 6, actionf_t(void, void, void), statenum_t.S_BON1, 0, 0),
state_t(spritenum_t.SPR_BON2, 0, 6, actionf_t(void, void, void), statenum_t.S_BON2A, 0, 0),
state_t(spritenum_t.SPR_BON2, 1, 6, actionf_t(void, void, void), statenum_t.S_BON2B, 0, 0),
state_t(spritenum_t.SPR_BON2, 2, 6, actionf_t(void, void, void), statenum_t.S_BON2C, 0, 0),
state_t(spritenum_t.SPR_BON2, 3, 6, actionf_t(void, void, void), statenum_t.S_BON2D, 0, 0),
state_t(spritenum_t.SPR_BON2, 2, 6, actionf_t(void, void, void), statenum_t.S_BON2E, 0, 0),
state_t(spritenum_t.SPR_BON2, 1, 6, actionf_t(void, void, void), statenum_t.S_BON2, 0, 0),
state_t(spritenum_t.SPR_BKEY, 0, 10, actionf_t(void, void, void), statenum_t.S_BKEY2, 0, 0),
state_t(spritenum_t.SPR_BKEY, 32769, 10, actionf_t(void, void, void), statenum_t.S_BKEY, 0, 0),
state_t(spritenum_t.SPR_RKEY, 0, 10, actionf_t(void, void, void), statenum_t.S_RKEY2, 0, 0),
state_t(spritenum_t.SPR_RKEY, 32769, 10, actionf_t(void, void, void), statenum_t.S_RKEY, 0, 0),
state_t(spritenum_t.SPR_YKEY, 0, 10, actionf_t(void, void, void), statenum_t.S_YKEY2, 0, 0),
state_t(spritenum_t.SPR_YKEY, 32769, 10, actionf_t(void, void, void), statenum_t.S_YKEY, 0, 0),
state_t(spritenum_t.SPR_BSKU, 0, 10, actionf_t(void, void, void), statenum_t.S_BSKULL2, 0, 0),
state_t(spritenum_t.SPR_BSKU, 32769, 10, actionf_t(void, void, void), statenum_t.S_BSKULL, 0, 0),
state_t(spritenum_t.SPR_RSKU, 0, 10, actionf_t(void, void, void), statenum_t.S_RSKULL2, 0, 0),
state_t(spritenum_t.SPR_RSKU, 32769, 10, actionf_t(void, void, void), statenum_t.S_RSKULL, 0, 0),
state_t(spritenum_t.SPR_YSKU, 0, 10, actionf_t(void, void, void), statenum_t.S_YSKULL2, 0, 0),
state_t(spritenum_t.SPR_YSKU, 32769, 10, actionf_t(void, void, void), statenum_t.S_YSKULL, 0, 0),
state_t(spritenum_t.SPR_STIM, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_MEDI, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32768, 6, actionf_t(void, void, void), statenum_t.S_SOUL2, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32769, 6, actionf_t(void, void, void), statenum_t.S_SOUL3, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32770, 6, actionf_t(void, void, void), statenum_t.S_SOUL4, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32771, 6, actionf_t(void, void, void), statenum_t.S_SOUL5, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32770, 6, actionf_t(void, void, void), statenum_t.S_SOUL6, 0, 0),
state_t(spritenum_t.SPR_SOUL, 32769, 6, actionf_t(void, void, void), statenum_t.S_SOUL, 0, 0),
state_t(spritenum_t.SPR_PINV, 32768, 6, actionf_t(void, void, void), statenum_t.S_PINV2, 0, 0),
state_t(spritenum_t.SPR_PINV, 32769, 6, actionf_t(void, void, void), statenum_t.S_PINV3, 0, 0),
state_t(spritenum_t.SPR_PINV, 32770, 6, actionf_t(void, void, void), statenum_t.S_PINV4, 0, 0),
state_t(spritenum_t.SPR_PINV, 32771, 6, actionf_t(void, void, void), statenum_t.S_PINV, 0, 0),
state_t(spritenum_t.SPR_PSTR, 32768, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PINS, 32768, 6, actionf_t(void, void, void), statenum_t.S_PINS2, 0, 0),
state_t(spritenum_t.SPR_PINS, 32769, 6, actionf_t(void, void, void), statenum_t.S_PINS3, 0, 0),
state_t(spritenum_t.SPR_PINS, 32770, 6, actionf_t(void, void, void), statenum_t.S_PINS4, 0, 0),
state_t(spritenum_t.SPR_PINS, 32771, 6, actionf_t(void, void, void), statenum_t.S_PINS, 0, 0),
state_t(spritenum_t.SPR_MEGA, 32768, 6, actionf_t(void, void, void), statenum_t.S_MEGA2, 0, 0),
state_t(spritenum_t.SPR_MEGA, 32769, 6, actionf_t(void, void, void), statenum_t.S_MEGA3, 0, 0),
state_t(spritenum_t.SPR_MEGA, 32770, 6, actionf_t(void, void, void), statenum_t.S_MEGA4, 0, 0),
state_t(spritenum_t.SPR_MEGA, 32771, 6, actionf_t(void, void, void), statenum_t.S_MEGA, 0, 0),
state_t(spritenum_t.SPR_SUIT, 32768, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32768, 6, actionf_t(void, void, void), statenum_t.S_PMAP2, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32769, 6, actionf_t(void, void, void), statenum_t.S_PMAP3, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32770, 6, actionf_t(void, void, void), statenum_t.S_PMAP4, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32771, 6, actionf_t(void, void, void), statenum_t.S_PMAP5, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32770, 6, actionf_t(void, void, void), statenum_t.S_PMAP6, 0, 0),
state_t(spritenum_t.SPR_PMAP, 32769, 6, actionf_t(void, void, void), statenum_t.S_PMAP, 0, 0),
state_t(spritenum_t.SPR_PVIS, 32768, 6, actionf_t(void, void, void), statenum_t.S_PVIS2, 0, 0),
state_t(spritenum_t.SPR_PVIS, 1, 6, actionf_t(void, void, void), statenum_t.S_PVIS, 0, 0),
state_t(spritenum_t.SPR_CLIP, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_AMMO, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_ROCK, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BROK, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CELL, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CELP, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SHEL, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SBOX, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BPAK, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BFUG, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_MGUN, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CSAW, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_LAUN, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLAS, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SHOT, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SGN2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COLU, 32768, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SMT2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_GOR1, 0, 10, actionf_t(void, void, void), statenum_t.S_BLOODYTWITCH2, 0, 0),
state_t(spritenum_t.SPR_GOR1, 1, 15, actionf_t(void, void, void), statenum_t.S_BLOODYTWITCH3, 0, 0),
state_t(spritenum_t.SPR_GOR1, 2, 8, actionf_t(void, void, void), statenum_t.S_BLOODYTWITCH4, 0, 0),
state_t(spritenum_t.SPR_GOR1, 1, 6, actionf_t(void, void, void), statenum_t.S_BLOODYTWITCH, 0, 0),
state_t(spritenum_t.SPR_PLAY, 13, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_PLAY, 18, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POL2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POL5, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POL4, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POL3, 32768, 6, actionf_t(void, void, void), statenum_t.S_HEADCANDLES2, 0, 0),
state_t(spritenum_t.SPR_POL3, 32769, 6, actionf_t(void, void, void), statenum_t.S_HEADCANDLES, 0, 0),
state_t(spritenum_t.SPR_POL1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POL6, 0, 6, actionf_t(void, void, void), statenum_t.S_LIVESTICK2, 0, 0),
state_t(spritenum_t.SPR_POL6, 1, 8, actionf_t(void, void, void), statenum_t.S_LIVESTICK, 0, 0),
state_t(spritenum_t.SPR_GOR2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_GOR3, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_GOR4, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_GOR5, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_SMIT, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COL1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COL2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COL3, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COL4, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CAND, 32768, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CBRA, 32768, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_COL6, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TRE1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TRE2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_ELEC, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_CEYE, 32768, 6, actionf_t(void, void, void), statenum_t.S_EVILEYE2, 0, 0),
state_t(spritenum_t.SPR_CEYE, 32769, 6, actionf_t(void, void, void), statenum_t.S_EVILEYE3, 0, 0),
state_t(spritenum_t.SPR_CEYE, 32770, 6, actionf_t(void, void, void), statenum_t.S_EVILEYE4, 0, 0),
state_t(spritenum_t.SPR_CEYE, 32769, 6, actionf_t(void, void, void), statenum_t.S_EVILEYE, 0, 0),
state_t(spritenum_t.SPR_FSKU, 32768, 6, actionf_t(void, void, void), statenum_t.S_FLOATSKULL2, 0, 0),
state_t(spritenum_t.SPR_FSKU, 32769, 6, actionf_t(void, void, void), statenum_t.S_FLOATSKULL3, 0, 0),
state_t(spritenum_t.SPR_FSKU, 32770, 6, actionf_t(void, void, void), statenum_t.S_FLOATSKULL, 0, 0),
state_t(spritenum_t.SPR_COL5, 0, 14, actionf_t(void, void, void), statenum_t.S_HEARTCOL2, 0, 0),
state_t(spritenum_t.SPR_COL5, 1, 14, actionf_t(void, void, void), statenum_t.S_HEARTCOL, 0, 0),
state_t(spritenum_t.SPR_TBLU, 32768, 4, actionf_t(void, void, void), statenum_t.S_BLUETORCH2, 0, 0),
state_t(spritenum_t.SPR_TBLU, 32769, 4, actionf_t(void, void, void), statenum_t.S_BLUETORCH3, 0, 0),
state_t(spritenum_t.SPR_TBLU, 32770, 4, actionf_t(void, void, void), statenum_t.S_BLUETORCH4, 0, 0),
state_t(spritenum_t.SPR_TBLU, 32771, 4, actionf_t(void, void, void), statenum_t.S_BLUETORCH, 0, 0),
state_t(spritenum_t.SPR_TGRN, 32768, 4, actionf_t(void, void, void), statenum_t.S_GREENTORCH2, 0, 0),
state_t(spritenum_t.SPR_TGRN, 32769, 4, actionf_t(void, void, void), statenum_t.S_GREENTORCH3, 0, 0),
state_t(spritenum_t.SPR_TGRN, 32770, 4, actionf_t(void, void, void), statenum_t.S_GREENTORCH4, 0, 0),
state_t(spritenum_t.SPR_TGRN, 32771, 4, actionf_t(void, void, void), statenum_t.S_GREENTORCH, 0, 0),
state_t(spritenum_t.SPR_TRED, 32768, 4, actionf_t(void, void, void), statenum_t.S_REDTORCH2, 0, 0),
state_t(spritenum_t.SPR_TRED, 32769, 4, actionf_t(void, void, void), statenum_t.S_REDTORCH3, 0, 0),
state_t(spritenum_t.SPR_TRED, 32770, 4, actionf_t(void, void, void), statenum_t.S_REDTORCH4, 0, 0),
state_t(spritenum_t.SPR_TRED, 32771, 4, actionf_t(void, void, void), statenum_t.S_REDTORCH, 0, 0),
state_t(spritenum_t.SPR_SMBT, 32768, 4, actionf_t(void, void, void), statenum_t.S_BTORCHSHRT2, 0, 0),
state_t(spritenum_t.SPR_SMBT, 32769, 4, actionf_t(void, void, void), statenum_t.S_BTORCHSHRT3, 0, 0),
state_t(spritenum_t.SPR_SMBT, 32770, 4, actionf_t(void, void, void), statenum_t.S_BTORCHSHRT4, 0, 0),
state_t(spritenum_t.SPR_SMBT, 32771, 4, actionf_t(void, void, void), statenum_t.S_BTORCHSHRT, 0, 0),
state_t(spritenum_t.SPR_SMGT, 32768, 4, actionf_t(void, void, void), statenum_t.S_GTORCHSHRT2, 0, 0),
state_t(spritenum_t.SPR_SMGT, 32769, 4, actionf_t(void, void, void), statenum_t.S_GTORCHSHRT3, 0, 0),
state_t(spritenum_t.SPR_SMGT, 32770, 4, actionf_t(void, void, void), statenum_t.S_GTORCHSHRT4, 0, 0),
state_t(spritenum_t.SPR_SMGT, 32771, 4, actionf_t(void, void, void), statenum_t.S_GTORCHSHRT, 0, 0),
state_t(spritenum_t.SPR_SMRT, 32768, 4, actionf_t(void, void, void), statenum_t.S_RTORCHSHRT2, 0, 0),
state_t(spritenum_t.SPR_SMRT, 32769, 4, actionf_t(void, void, void), statenum_t.S_RTORCHSHRT3, 0, 0),
state_t(spritenum_t.SPR_SMRT, 32770, 4, actionf_t(void, void, void), statenum_t.S_RTORCHSHRT4, 0, 0),
state_t(spritenum_t.SPR_SMRT, 32771, 4, actionf_t(void, void, void), statenum_t.S_RTORCHSHRT, 0, 0),
state_t(spritenum_t.SPR_HDB1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HDB2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HDB3, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HDB4, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HDB5, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_HDB6, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POB1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_POB2, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_BRS1, 0, -1, actionf_t(void, void, void), statenum_t.S_NULL, 0, 0),
state_t(spritenum_t.SPR_TLMP, 32768, 4, actionf_t(void, void, void), statenum_t.S_TECHLAMP2, 0, 0),
state_t(spritenum_t.SPR_TLMP, 32769, 4, actionf_t(void, void, void), statenum_t.S_TECHLAMP3, 0, 0),
state_t(spritenum_t.SPR_TLMP, 32770, 4, actionf_t(void, void, void), statenum_t.S_TECHLAMP4, 0, 0),
state_t(spritenum_t.SPR_TLMP, 32771, 4, actionf_t(void, void, void), statenum_t.S_TECHLAMP, 0, 0),
state_t(spritenum_t.SPR_TLP2, 32768, 4, actionf_t(void, void, void), statenum_t.S_TECH2LAMP2, 0, 0),
state_t(spritenum_t.SPR_TLP2, 32769, 4, actionf_t(void, void, void), statenum_t.S_TECH2LAMP3, 0, 0),
state_t(spritenum_t.SPR_TLP2, 32770, 4, actionf_t(void, void, void), statenum_t.S_TECH2LAMP4, 0, 0),
state_t(spritenum_t.SPR_TLP2, 32771, 4, actionf_t(void, void, void), statenum_t.S_TECH2LAMP, 0, 0),
]
sprnames =[
"TROO", "SHTG", "PUNG", "PISG", "PISF", "SHTF", "SHT2", "CHGG", "CHGF", "MISG",
"MISF", "SAWG", "PLSG", "PLSF", "BFGG", "BFGF", "BLUD", "PUFF", "BAL1", "BAL2",
"PLSS", "PLSE", "MISL", "BFS1", "BFE1", "BFE2", "TFOG", "IFOG", "PLAY", "POSS",
"SPOS", "VILE", "FIRE", "FATB", "FBXP", "SKEL", "MANF", "FATT", "CPOS", "SARG",
"HEAD", "BAL7", "BOSS", "BOS2", "SKUL", "SPID", "BSPI", "APLS", "APBX", "CYBR",
"PAIN", "SSWV", "KEEN", "BBRN", "BOSF", "ARM1", "ARM2", "BAR1", "BEXP", "FCAN",
"BON1", "BON2", "BKEY", "RKEY", "YKEY", "BSKU", "RSKU", "YSKU", "STIM", "MEDI",
"SOUL", "PINV", "PSTR", "PINS", "MEGA", "SUIT", "PMAP", "PVIS", "CLIP", "AMMO",
"ROCK", "BROK", "CELL", "CELP", "SHEL", "SBOX", "BPAK", "BFUG", "MGUN", "CSAW",
"LAUN", "PLAS", "SHOT", "SGN2", "COLU", "SMT2", "GOR1", "POL2", "POL5", "POL4",
"POL3", "POL1", "POL6", "GOR2", "GOR3", "GOR4", "GOR5", "SMIT", "COL1", "COL2",
"COL3", "COL4", "CAND", "CBRA", "COL6", "TRE1", "TRE2", "ELEC", "CEYE", "FSKU",
"COL5", "TBLU", "TGRN", "TRED", "SMBT", "SMGT", "SMRT", "HDB1", "HDB2", "HDB3",
"HDB4", "HDB5", "HDB6", "POB1", "POB2", "BRS1", "TLMP", "TLP2",
]

/*
* Enum: mobjtype_t
* Purpose: Defines named constants for mobjtype type.
*/
enum mobjtype_t
  MT_PLAYER
  MT_POSSESSED
  MT_SHOTGUY
  MT_VILE
  MT_FIRE
  MT_UNDEAD
  MT_TRACER
  MT_SMOKE
  MT_FATSO
  MT_FATSHOT
  MT_CHAINGUY
  MT_TROOP
  MT_SERGEANT
  MT_SHADOWS
  MT_HEAD
  MT_BRUISER
  MT_BRUISERSHOT
  MT_KNIGHT
  MT_SKULL
  MT_SPIDER
  MT_BABY
  MT_CYBORG
  MT_PAIN
  MT_WOLFSS
  MT_KEEN
  MT_BOSSBRAIN
  MT_BOSSSPIT
  MT_BOSSTARGET
  MT_SPAWNSHOT
  MT_SPAWNFIRE
  MT_BARREL
  MT_TROOPSHOT
  MT_HEADSHOT
  MT_ROCKET
  MT_PLASMA
  MT_BFG
  MT_ARACHPLAZ
  MT_PUFF
  MT_BLOOD
  MT_TFOG
  MT_IFOG
  MT_TELEPORTMAN
  MT_EXTRABFG
  MT_MISC0
  MT_MISC1
  MT_MISC2
  MT_MISC3
  MT_MISC4
  MT_MISC5
  MT_MISC6
  MT_MISC7
  MT_MISC8
  MT_MISC9
  MT_MISC10
  MT_MISC11
  MT_MISC12
  MT_INV
  MT_MISC13
  MT_INS
  MT_MISC14
  MT_MISC15
  MT_MISC16
  MT_MEGA
  MT_CLIP
  MT_MISC17
  MT_MISC18
  MT_MISC19
  MT_MISC20
  MT_MISC21
  MT_MISC22
  MT_MISC23
  MT_MISC24
  MT_MISC25
  MT_CHAINGUN
  MT_MISC26
  MT_MISC27
  MT_MISC28
  MT_SHOTGUN
  MT_SUPERSHOTGUN
  MT_MISC29
  MT_MISC30
  MT_MISC31
  MT_MISC32
  MT_MISC33
  MT_MISC34
  MT_MISC35
  MT_MISC36
  MT_MISC37
  MT_MISC38
  MT_MISC39
  MT_MISC40
  MT_MISC41
  MT_MISC42
  MT_MISC43
  MT_MISC44
  MT_MISC45
  MT_MISC46
  MT_MISC47
  MT_MISC48
  MT_MISC49
  MT_MISC50
  MT_MISC51
  MT_MISC52
  MT_MISC53
  MT_MISC54
  MT_MISC55
  MT_MISC56
  MT_MISC57
  MT_MISC58
  MT_MISC59
  MT_MISC60
  MT_MISC61
  MT_MISC62
  MT_MISC63
  MT_MISC64
  MT_MISC65
  MT_MISC66
  MT_MISC67
  MT_MISC68
  MT_MISC69
  MT_MISC70
  MT_MISC71
  MT_MISC72
  MT_MISC73
  MT_MISC74
  MT_MISC75
  MT_MISC76
  MT_MISC77
  MT_MISC78
  MT_MISC79
  MT_MISC80
  MT_MISC81
  MT_MISC82
  MT_MISC83
  MT_MISC84
  MT_MISC85
  MT_MISC86
  NUMMOBJTYPES
end enum

/*
* Struct: mobjinfo_t
* Purpose: Stores runtime data for mobjinfo type.
*/
struct mobjinfo_t
  doomednum
  spawnstate
  spawnhealth
  seestate
  seesound
  reactiontime
  attacksound
  painstate
  painchance
  painsound
  meleestate
  missilestate
  deathstate
  xdeathstate
  deathsound
  speed
  radius
  height
  mass
  damage
  activesound
  flags
  raisestate
end struct

mobjinfo =[
mobjinfo_t(-1, statenum_t.S_PLAY, 100, statenum_t.S_PLAY_RUN1, sfxenum_t.sfx_None, 0, sfxenum_t.sfx_None, statenum_t.S_PLAY_PAIN, 255, sfxenum_t.sfx_plpain, statenum_t.S_NULL, statenum_t.S_PLAY_ATK1, statenum_t.S_PLAY_DIE1, statenum_t.S_PLAY_XDIE1, sfxenum_t.sfx_pldeth, 0, 16 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_PICKUP | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(3004, statenum_t.S_POSS_STND, 20, statenum_t.S_POSS_RUN1, sfxenum_t.sfx_posit1, 8, sfxenum_t.sfx_pistol, statenum_t.S_POSS_PAIN, 200, sfxenum_t.sfx_popain, 0, statenum_t.S_POSS_ATK1, statenum_t.S_POSS_DIE1, statenum_t.S_POSS_XDIE1, sfxenum_t.sfx_podth1, 8, 20 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_posact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_POSS_RAISE1),
mobjinfo_t(9, statenum_t.S_SPOS_STND, 30, statenum_t.S_SPOS_RUN1, sfxenum_t.sfx_posit2, 8, 0, statenum_t.S_SPOS_PAIN, 170, sfxenum_t.sfx_popain, 0, statenum_t.S_SPOS_ATK1, statenum_t.S_SPOS_DIE1, statenum_t.S_SPOS_XDIE1, sfxenum_t.sfx_podth2, 8, 20 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_posact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_SPOS_RAISE1),
mobjinfo_t(64, statenum_t.S_VILE_STND, 700, statenum_t.S_VILE_RUN1, sfxenum_t.sfx_vilsit, 8, 0, statenum_t.S_VILE_PAIN, 10, sfxenum_t.sfx_vipain, 0, statenum_t.S_VILE_ATK1, statenum_t.S_VILE_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_vildth, 15, 20 * FRACUNIT, 56 * FRACUNIT, 500, 0, sfxenum_t.sfx_vilact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_FIRE1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(66, statenum_t.S_SKEL_STND, 300, statenum_t.S_SKEL_RUN1, sfxenum_t.sfx_skesit, 8, 0, statenum_t.S_SKEL_PAIN, 100, sfxenum_t.sfx_popain, statenum_t.S_SKEL_FIST1, statenum_t.S_SKEL_MISS1, statenum_t.S_SKEL_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_skedth, 10, 20 * FRACUNIT, 56 * FRACUNIT, 500, 0, sfxenum_t.sfx_skeact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_SKEL_RAISE1),
mobjinfo_t(-1, statenum_t.S_TRACER, 1000, statenum_t.S_NULL, sfxenum_t.sfx_skeatk, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_TRACEEXP1, statenum_t.S_NULL, sfxenum_t.sfx_barexp, 10 * FRACUNIT, 11 * FRACUNIT, 8 * FRACUNIT, 100, 10, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_SMOKE1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(67, statenum_t.S_FATT_STND, 600, statenum_t.S_FATT_RUN1, sfxenum_t.sfx_mansit, 8, 0, statenum_t.S_FATT_PAIN, 80, sfxenum_t.sfx_mnpain, 0, statenum_t.S_FATT_ATK1, statenum_t.S_FATT_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_mandth, 8, 48 * FRACUNIT, 64 * FRACUNIT, 1000, 0, sfxenum_t.sfx_posact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_FATT_RAISE1),
mobjinfo_t(-1, statenum_t.S_FATSHOT1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_firsht, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_FATSHOTX1, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 20 * FRACUNIT, 6 * FRACUNIT, 8 * FRACUNIT, 100, 8, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(65, statenum_t.S_CPOS_STND, 70, statenum_t.S_CPOS_RUN1, sfxenum_t.sfx_posit2, 8, 0, statenum_t.S_CPOS_PAIN, 170, sfxenum_t.sfx_popain, 0, statenum_t.S_CPOS_ATK1, statenum_t.S_CPOS_DIE1, statenum_t.S_CPOS_XDIE1, sfxenum_t.sfx_podth2, 8, 20 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_posact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_CPOS_RAISE1),
mobjinfo_t(3001, statenum_t.S_TROO_STND, 60, statenum_t.S_TROO_RUN1, sfxenum_t.sfx_bgsit1, 8, 0, statenum_t.S_TROO_PAIN, 200, sfxenum_t.sfx_popain, statenum_t.S_TROO_ATK1, statenum_t.S_TROO_ATK1, statenum_t.S_TROO_DIE1, statenum_t.S_TROO_XDIE1, sfxenum_t.sfx_bgdth1, 8, 20 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_bgact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_TROO_RAISE1),
mobjinfo_t(3002, statenum_t.S_SARG_STND, 150, statenum_t.S_SARG_RUN1, sfxenum_t.sfx_sgtsit, 8, sfxenum_t.sfx_sgtatk, statenum_t.S_SARG_PAIN, 180, sfxenum_t.sfx_dmpain, statenum_t.S_SARG_ATK1, 0, statenum_t.S_SARG_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_sgtdth, 10, 30 * FRACUNIT, 56 * FRACUNIT, 400, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_SARG_RAISE1),
mobjinfo_t(58, statenum_t.S_SARG_STND, 150, statenum_t.S_SARG_RUN1, sfxenum_t.sfx_sgtsit, 8, sfxenum_t.sfx_sgtatk, statenum_t.S_SARG_PAIN, 180, sfxenum_t.sfx_dmpain, statenum_t.S_SARG_ATK1, 0, statenum_t.S_SARG_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_sgtdth, 10, 30 * FRACUNIT, 56 * FRACUNIT, 400, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_SHADOW | mobjflag_t.MF_COUNTKILL, statenum_t.S_SARG_RAISE1),
mobjinfo_t(3005, statenum_t.S_HEAD_STND, 400, statenum_t.S_HEAD_RUN1, sfxenum_t.sfx_cacsit, 8, 0, statenum_t.S_HEAD_PAIN, 128, sfxenum_t.sfx_dmpain, 0, statenum_t.S_HEAD_ATK1, statenum_t.S_HEAD_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_cacdth, 8, 31 * FRACUNIT, 56 * FRACUNIT, 400, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_FLOAT | mobjflag_t.MF_NOGRAVITY | mobjflag_t.MF_COUNTKILL, statenum_t.S_HEAD_RAISE1),
mobjinfo_t(3003, statenum_t.S_BOSS_STND, 1000, statenum_t.S_BOSS_RUN1, sfxenum_t.sfx_brssit, 8, 0, statenum_t.S_BOSS_PAIN, 50, sfxenum_t.sfx_dmpain, statenum_t.S_BOSS_ATK1, statenum_t.S_BOSS_ATK1, statenum_t.S_BOSS_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_brsdth, 8, 24 * FRACUNIT, 64 * FRACUNIT, 1000, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_BOSS_RAISE1),
mobjinfo_t(-1, statenum_t.S_BRBALL1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_firsht, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_BRBALLX1, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 15 * FRACUNIT, 6 * FRACUNIT, 8 * FRACUNIT, 100, 8, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(69, statenum_t.S_BOS2_STND, 500, statenum_t.S_BOS2_RUN1, sfxenum_t.sfx_kntsit, 8, 0, statenum_t.S_BOS2_PAIN, 50, sfxenum_t.sfx_dmpain, statenum_t.S_BOS2_ATK1, statenum_t.S_BOS2_ATK1, statenum_t.S_BOS2_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_kntdth, 8, 24 * FRACUNIT, 64 * FRACUNIT, 1000, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_BOS2_RAISE1),
mobjinfo_t(3006, statenum_t.S_SKULL_STND, 100, statenum_t.S_SKULL_RUN1, 0, 8, sfxenum_t.sfx_sklatk, statenum_t.S_SKULL_PAIN, 256, sfxenum_t.sfx_dmpain, 0, statenum_t.S_SKULL_ATK1, statenum_t.S_SKULL_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 8, 16 * FRACUNIT, 56 * FRACUNIT, 50, 3, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_FLOAT | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(7, statenum_t.S_SPID_STND, 3000, statenum_t.S_SPID_RUN1, sfxenum_t.sfx_spisit, 8, sfxenum_t.sfx_shotgn, statenum_t.S_SPID_PAIN, 40, sfxenum_t.sfx_dmpain, 0, statenum_t.S_SPID_ATK1, statenum_t.S_SPID_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_spidth, 12, 128 * FRACUNIT, 100 * FRACUNIT, 1000, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_NULL),
mobjinfo_t(68, statenum_t.S_BSPI_STND, 500, statenum_t.S_BSPI_SIGHT, sfxenum_t.sfx_bspsit, 8, 0, statenum_t.S_BSPI_PAIN, 128, sfxenum_t.sfx_dmpain, 0, statenum_t.S_BSPI_ATK1, statenum_t.S_BSPI_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_bspdth, 12, 64 * FRACUNIT, 64 * FRACUNIT, 600, 0, sfxenum_t.sfx_bspact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_BSPI_RAISE1),
mobjinfo_t(16, statenum_t.S_CYBER_STND, 4000, statenum_t.S_CYBER_RUN1, sfxenum_t.sfx_cybsit, 8, 0, statenum_t.S_CYBER_PAIN, 20, sfxenum_t.sfx_dmpain, 0, statenum_t.S_CYBER_ATK1, statenum_t.S_CYBER_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_cybdth, 16, 40 * FRACUNIT, 110 * FRACUNIT, 1000, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_NULL),
mobjinfo_t(71, statenum_t.S_PAIN_STND, 400, statenum_t.S_PAIN_RUN1, sfxenum_t.sfx_pesit, 8, 0, statenum_t.S_PAIN_PAIN, 128, sfxenum_t.sfx_pepain, 0, statenum_t.S_PAIN_ATK1, statenum_t.S_PAIN_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_pedth, 8, 31 * FRACUNIT, 56 * FRACUNIT, 400, 0, sfxenum_t.sfx_dmact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_FLOAT | mobjflag_t.MF_NOGRAVITY | mobjflag_t.MF_COUNTKILL, statenum_t.S_PAIN_RAISE1),
mobjinfo_t(84, statenum_t.S_SSWV_STND, 50, statenum_t.S_SSWV_RUN1, sfxenum_t.sfx_sssit, 8, 0, statenum_t.S_SSWV_PAIN, 170, sfxenum_t.sfx_popain, 0, statenum_t.S_SSWV_ATK1, statenum_t.S_SSWV_DIE1, statenum_t.S_SSWV_XDIE1, sfxenum_t.sfx_ssdth, 8, 20 * FRACUNIT, 56 * FRACUNIT, 100, 0, sfxenum_t.sfx_posact, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_SSWV_RAISE1),
mobjinfo_t(72, statenum_t.S_KEENSTND, 100, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_KEENPAIN, 256, sfxenum_t.sfx_keenpn, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_COMMKEEN, statenum_t.S_NULL, sfxenum_t.sfx_keendt, 0, 16 * FRACUNIT, 72 * FRACUNIT, 10000000, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_COUNTKILL, statenum_t.S_NULL),
mobjinfo_t(88, statenum_t.S_BRAIN, 250, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_BRAIN_PAIN, 255, sfxenum_t.sfx_bospn, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_BRAIN_DIE1, statenum_t.S_NULL, sfxenum_t.sfx_bosdth, 0, 16 * FRACUNIT, 16 * FRACUNIT, 10000000, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE, statenum_t.S_NULL),
mobjinfo_t(89, statenum_t.S_BRAINEYE, 1000, statenum_t.S_BRAINEYESEE, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 32 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOSECTOR, statenum_t.S_NULL),
mobjinfo_t(87, statenum_t.S_NULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 32 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOSECTOR, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_SPAWN1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_bospit, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 10 * FRACUNIT, 6 * FRACUNIT, 32 * FRACUNIT, 100, 3, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY | mobjflag_t.MF_NOCLIP, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_SPAWNFIRE1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(2035, statenum_t.S_BAR1, 20, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_BEXP, statenum_t.S_NULL, sfxenum_t.sfx_barexp, 0, 10 * FRACUNIT, 42 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SHOOTABLE | mobjflag_t.MF_NOBLOOD, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_TBALL1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_firsht, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_TBALLX1, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 10 * FRACUNIT, 6 * FRACUNIT, 8 * FRACUNIT, 100, 3, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_RBALL1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_firsht, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_RBALLX1, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 10 * FRACUNIT, 6 * FRACUNIT, 8 * FRACUNIT, 100, 5, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_ROCKET, 1000, statenum_t.S_NULL, sfxenum_t.sfx_rlaunc, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_EXPLODE1, statenum_t.S_NULL, sfxenum_t.sfx_barexp, 20 * FRACUNIT, 11 * FRACUNIT, 8 * FRACUNIT, 100, 20, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_PLASBALL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_plasma, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_PLASEXP, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 25 * FRACUNIT, 13 * FRACUNIT, 8 * FRACUNIT, 100, 5, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_BFGSHOT, 1000, statenum_t.S_NULL, 0, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_BFGLAND, statenum_t.S_NULL, sfxenum_t.sfx_rxplod, 25 * FRACUNIT, 13 * FRACUNIT, 8 * FRACUNIT, 100, 100, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_ARACH_PLAZ, 1000, statenum_t.S_NULL, sfxenum_t.sfx_plasma, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_ARACH_PLEX, statenum_t.S_NULL, sfxenum_t.sfx_firxpl, 25 * FRACUNIT, 13 * FRACUNIT, 8 * FRACUNIT, 100, 5, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_MISSILE | mobjflag_t.MF_DROPOFF | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_PUFF1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_BLOOD1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_TFOG, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_IFOG, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(14, statenum_t.S_NULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOSECTOR, statenum_t.S_NULL),
mobjinfo_t(-1, statenum_t.S_BFGEXP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(2018, statenum_t.S_ARM1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2019, statenum_t.S_ARM2, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2014, statenum_t.S_BON1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2015, statenum_t.S_BON2, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(5, statenum_t.S_BKEY, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(13, statenum_t.S_RKEY, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(6, statenum_t.S_YKEY, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(39, statenum_t.S_YSKULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(38, statenum_t.S_RSKULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(40, statenum_t.S_BSKULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_NOTDMATCH, statenum_t.S_NULL),
mobjinfo_t(2011, statenum_t.S_STIM, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2012, statenum_t.S_MEDI, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2013, statenum_t.S_SOUL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2022, statenum_t.S_PINV, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2023, statenum_t.S_PSTR, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2024, statenum_t.S_PINS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2025, statenum_t.S_SUIT, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2026, statenum_t.S_PMAP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2045, statenum_t.S_PVIS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(83, statenum_t.S_MEGA, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL | mobjflag_t.MF_COUNTITEM, statenum_t.S_NULL),
mobjinfo_t(2007, statenum_t.S_CLIP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2048, statenum_t.S_AMMO, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2010, statenum_t.S_ROCK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2046, statenum_t.S_BROK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2047, statenum_t.S_CELL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(17, statenum_t.S_CELP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2008, statenum_t.S_SHEL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2049, statenum_t.S_SBOX, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(8, statenum_t.S_BPAK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2006, statenum_t.S_BFUG, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2002, statenum_t.S_MGUN, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2005, statenum_t.S_CSAW, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2003, statenum_t.S_LAUN, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2004, statenum_t.S_PLAS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(2001, statenum_t.S_SHOT, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(82, statenum_t.S_SHOT2, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPECIAL, statenum_t.S_NULL),
mobjinfo_t(85, statenum_t.S_TECHLAMP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(86, statenum_t.S_TECH2LAMP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(2028, statenum_t.S_COLU, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(30, statenum_t.S_TALLGRNCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(31, statenum_t.S_SHRTGRNCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(32, statenum_t.S_TALLREDCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(33, statenum_t.S_SHRTREDCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(37, statenum_t.S_SKULLCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(36, statenum_t.S_HEARTCOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(41, statenum_t.S_EVILEYE, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(42, statenum_t.S_FLOATSKULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(43, statenum_t.S_TORCHTREE, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(44, statenum_t.S_BLUETORCH, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(45, statenum_t.S_GREENTORCH, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(46, statenum_t.S_REDTORCH, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(55, statenum_t.S_BTORCHSHRT, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(56, statenum_t.S_GTORCHSHRT, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(57, statenum_t.S_RTORCHSHRT, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(47, statenum_t.S_STALAGTITE, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(48, statenum_t.S_TECHPILLAR, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(34, statenum_t.S_CANDLESTIK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(35, statenum_t.S_CANDELABRA, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(49, statenum_t.S_BLOODYTWITCH, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 68 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(50, statenum_t.S_MEAT2, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 84 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(51, statenum_t.S_MEAT3, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 84 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(52, statenum_t.S_MEAT4, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 68 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(53, statenum_t.S_MEAT5, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 52 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(59, statenum_t.S_MEAT2, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 84 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(60, statenum_t.S_MEAT4, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 68 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(61, statenum_t.S_MEAT3, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 52 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(62, statenum_t.S_MEAT5, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 52 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(63, statenum_t.S_BLOODYTWITCH, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 68 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(22, statenum_t.S_HEAD_DIE6, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(15, statenum_t.S_PLAY_DIE7, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(18, statenum_t.S_POSS_DIE5, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(21, statenum_t.S_SARG_DIE6, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(23, statenum_t.S_SKULL_DIE6, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(20, statenum_t.S_TROO_DIE5, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(19, statenum_t.S_SPOS_DIE5, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(10, statenum_t.S_PLAY_XDIE9, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(12, statenum_t.S_PLAY_XDIE9, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(28, statenum_t.S_HEADSONSTICK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(24, statenum_t.S_GIBS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, 0, statenum_t.S_NULL),
mobjinfo_t(27, statenum_t.S_HEADONASTICK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(29, statenum_t.S_HEADCANDLES, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(25, statenum_t.S_DEADSTICK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(26, statenum_t.S_LIVESTICK, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(54, statenum_t.S_BIGTREE, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 32 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(70, statenum_t.S_BBAR1, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID, statenum_t.S_NULL),
mobjinfo_t(73, statenum_t.S_HANGNOGUTS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 88 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(74, statenum_t.S_HANGBNOBRAIN, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 88 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(75, statenum_t.S_HANGTLOOKDN, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 64 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(76, statenum_t.S_HANGTSKULL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 64 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(77, statenum_t.S_HANGTLOOKUP, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 64 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(78, statenum_t.S_HANGTNOBRAIN, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 16 * FRACUNIT, 64 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_SOLID | mobjflag_t.MF_SPAWNCEILING | mobjflag_t.MF_NOGRAVITY, statenum_t.S_NULL),
mobjinfo_t(79, statenum_t.S_COLONGIBS, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP, statenum_t.S_NULL),
mobjinfo_t(80, statenum_t.S_SMALLPOOL, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP, statenum_t.S_NULL),
mobjinfo_t(81, statenum_t.S_BRAINSTEM, 1000, statenum_t.S_NULL, sfxenum_t.sfx_None, 8, sfxenum_t.sfx_None, statenum_t.S_NULL, 0, sfxenum_t.sfx_None, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, statenum_t.S_NULL, sfxenum_t.sfx_None, 0, 20 * FRACUNIT, 16 * FRACUNIT, 100, 0, sfxenum_t.sfx_None, mobjflag_t.MF_NOBLOCKMAP, statenum_t.S_NULL),
]

/*
* Function: Info_StateIndex
* Purpose: Implements the Info_StateIndex routine for the engine module behavior.
*/
function Info_StateIndex(s)
  if typeof(s) == "int" then
    return s
  end if
  switch s
    case statenum_t.S_NULL
      return 0
    end case
    case statenum_t.S_LIGHTDONE
      return 1
    end case
    case statenum_t.S_PUNCH
      return 2
    end case
    case statenum_t.S_PUNCHDOWN
      return 3
    end case
    case statenum_t.S_PUNCHUP
      return 4
    end case
    case statenum_t.S_PUNCH1
      return 5
    end case
    case statenum_t.S_PUNCH2
      return 6
    end case
    case statenum_t.S_PUNCH3
      return 7
    end case
    case statenum_t.S_PUNCH4
      return 8
    end case
    case statenum_t.S_PUNCH5
      return 9
    end case
    case statenum_t.S_PISTOL
      return 10
    end case
    case statenum_t.S_PISTOLDOWN
      return 11
    end case
    case statenum_t.S_PISTOLUP
      return 12
    end case
    case statenum_t.S_PISTOL1
      return 13
    end case
    case statenum_t.S_PISTOL2
      return 14
    end case
    case statenum_t.S_PISTOL3
      return 15
    end case
    case statenum_t.S_PISTOL4
      return 16
    end case
    case statenum_t.S_PISTOLFLASH
      return 17
    end case
    case statenum_t.S_SGUN
      return 18
    end case
    case statenum_t.S_SGUNDOWN
      return 19
    end case
    case statenum_t.S_SGUNUP
      return 20
    end case
    case statenum_t.S_SGUN1
      return 21
    end case
    case statenum_t.S_SGUN2
      return 22
    end case
    case statenum_t.S_SGUN3
      return 23
    end case
    case statenum_t.S_SGUN4
      return 24
    end case
    case statenum_t.S_SGUN5
      return 25
    end case
    case statenum_t.S_SGUN6
      return 26
    end case
    case statenum_t.S_SGUN7
      return 27
    end case
    case statenum_t.S_SGUN8
      return 28
    end case
    case statenum_t.S_SGUN9
      return 29
    end case
    case statenum_t.S_SGUNFLASH1
      return 30
    end case
    case statenum_t.S_SGUNFLASH2
      return 31
    end case
    case statenum_t.S_DSGUN
      return 32
    end case
    case statenum_t.S_DSGUNDOWN
      return 33
    end case
    case statenum_t.S_DSGUNUP
      return 34
    end case
    case statenum_t.S_DSGUN1
      return 35
    end case
    case statenum_t.S_DSGUN2
      return 36
    end case
    case statenum_t.S_DSGUN3
      return 37
    end case
    case statenum_t.S_DSGUN4
      return 38
    end case
    case statenum_t.S_DSGUN5
      return 39
    end case
    case statenum_t.S_DSGUN6
      return 40
    end case
    case statenum_t.S_DSGUN7
      return 41
    end case
    case statenum_t.S_DSGUN8
      return 42
    end case
    case statenum_t.S_DSGUN9
      return 43
    end case
    case statenum_t.S_DSGUN10
      return 44
    end case
    case statenum_t.S_DSNR1
      return 45
    end case
    case statenum_t.S_DSNR2
      return 46
    end case
    case statenum_t.S_DSGUNFLASH1
      return 47
    end case
    case statenum_t.S_DSGUNFLASH2
      return 48
    end case
    case statenum_t.S_CHAIN
      return 49
    end case
    case statenum_t.S_CHAINDOWN
      return 50
    end case
    case statenum_t.S_CHAINUP
      return 51
    end case
    case statenum_t.S_CHAIN1
      return 52
    end case
    case statenum_t.S_CHAIN2
      return 53
    end case
    case statenum_t.S_CHAIN3
      return 54
    end case
    case statenum_t.S_CHAINFLASH1
      return 55
    end case
    case statenum_t.S_CHAINFLASH2
      return 56
    end case
    case statenum_t.S_MISSILE
      return 57
    end case
    case statenum_t.S_MISSILEDOWN
      return 58
    end case
    case statenum_t.S_MISSILEUP
      return 59
    end case
    case statenum_t.S_MISSILE1
      return 60
    end case
    case statenum_t.S_MISSILE2
      return 61
    end case
    case statenum_t.S_MISSILE3
      return 62
    end case
    case statenum_t.S_MISSILEFLASH1
      return 63
    end case
    case statenum_t.S_MISSILEFLASH2
      return 64
    end case
    case statenum_t.S_MISSILEFLASH3
      return 65
    end case
    case statenum_t.S_MISSILEFLASH4
      return 66
    end case
    case statenum_t.S_SAW
      return 67
    end case
    case statenum_t.S_SAWB
      return 68
    end case
    case statenum_t.S_SAWDOWN
      return 69
    end case
    case statenum_t.S_SAWUP
      return 70
    end case
    case statenum_t.S_SAW1
      return 71
    end case
    case statenum_t.S_SAW2
      return 72
    end case
    case statenum_t.S_SAW3
      return 73
    end case
    case statenum_t.S_PLASMA
      return 74
    end case
    case statenum_t.S_PLASMADOWN
      return 75
    end case
    case statenum_t.S_PLASMAUP
      return 76
    end case
    case statenum_t.S_PLASMA1
      return 77
    end case
    case statenum_t.S_PLASMA2
      return 78
    end case
    case statenum_t.S_PLASMAFLASH1
      return 79
    end case
    case statenum_t.S_PLASMAFLASH2
      return 80
    end case
    case statenum_t.S_BFG
      return 81
    end case
    case statenum_t.S_BFGDOWN
      return 82
    end case
    case statenum_t.S_BFGUP
      return 83
    end case
    case statenum_t.S_BFG1
      return 84
    end case
    case statenum_t.S_BFG2
      return 85
    end case
    case statenum_t.S_BFG3
      return 86
    end case
    case statenum_t.S_BFG4
      return 87
    end case
    case statenum_t.S_BFGFLASH1
      return 88
    end case
    case statenum_t.S_BFGFLASH2
      return 89
    end case
    case statenum_t.S_BLOOD1
      return 90
    end case
    case statenum_t.S_BLOOD2
      return 91
    end case
    case statenum_t.S_BLOOD3
      return 92
    end case
    case statenum_t.S_PUFF1
      return 93
    end case
    case statenum_t.S_PUFF2
      return 94
    end case
    case statenum_t.S_PUFF3
      return 95
    end case
    case statenum_t.S_PUFF4
      return 96
    end case
    case statenum_t.S_TBALL1
      return 97
    end case
    case statenum_t.S_TBALL2
      return 98
    end case
    case statenum_t.S_TBALLX1
      return 99
    end case
    case statenum_t.S_TBALLX2
      return 100
    end case
    case statenum_t.S_TBALLX3
      return 101
    end case
    case statenum_t.S_RBALL1
      return 102
    end case
    case statenum_t.S_RBALL2
      return 103
    end case
    case statenum_t.S_RBALLX1
      return 104
    end case
    case statenum_t.S_RBALLX2
      return 105
    end case
    case statenum_t.S_RBALLX3
      return 106
    end case
    case statenum_t.S_PLASBALL
      return 107
    end case
    case statenum_t.S_PLASBALL2
      return 108
    end case
    case statenum_t.S_PLASEXP
      return 109
    end case
    case statenum_t.S_PLASEXP2
      return 110
    end case
    case statenum_t.S_PLASEXP3
      return 111
    end case
    case statenum_t.S_PLASEXP4
      return 112
    end case
    case statenum_t.S_PLASEXP5
      return 113
    end case
    case statenum_t.S_ROCKET
      return 114
    end case
    case statenum_t.S_BFGSHOT
      return 115
    end case
    case statenum_t.S_BFGSHOT2
      return 116
    end case
    case statenum_t.S_BFGLAND
      return 117
    end case
    case statenum_t.S_BFGLAND2
      return 118
    end case
    case statenum_t.S_BFGLAND3
      return 119
    end case
    case statenum_t.S_BFGLAND4
      return 120
    end case
    case statenum_t.S_BFGLAND5
      return 121
    end case
    case statenum_t.S_BFGLAND6
      return 122
    end case
    case statenum_t.S_BFGEXP
      return 123
    end case
    case statenum_t.S_BFGEXP2
      return 124
    end case
    case statenum_t.S_BFGEXP3
      return 125
    end case
    case statenum_t.S_BFGEXP4
      return 126
    end case
    case statenum_t.S_EXPLODE1
      return 127
    end case
    case statenum_t.S_EXPLODE2
      return 128
    end case
    case statenum_t.S_EXPLODE3
      return 129
    end case
    case statenum_t.S_TFOG
      return 130
    end case
    case statenum_t.S_TFOG01
      return 131
    end case
    case statenum_t.S_TFOG02
      return 132
    end case
    case statenum_t.S_TFOG2
      return 133
    end case
    case statenum_t.S_TFOG3
      return 134
    end case
    case statenum_t.S_TFOG4
      return 135
    end case
    case statenum_t.S_TFOG5
      return 136
    end case
    case statenum_t.S_TFOG6
      return 137
    end case
    case statenum_t.S_TFOG7
      return 138
    end case
    case statenum_t.S_TFOG8
      return 139
    end case
    case statenum_t.S_TFOG9
      return 140
    end case
    case statenum_t.S_TFOG10
      return 141
    end case
    case statenum_t.S_IFOG
      return 142
    end case
    case statenum_t.S_IFOG01
      return 143
    end case
    case statenum_t.S_IFOG02
      return 144
    end case
    case statenum_t.S_IFOG2
      return 145
    end case
    case statenum_t.S_IFOG3
      return 146
    end case
    case statenum_t.S_IFOG4
      return 147
    end case
    case statenum_t.S_IFOG5
      return 148
    end case
    case statenum_t.S_PLAY
      return 149
    end case
    case statenum_t.S_PLAY_RUN1
      return 150
    end case
    case statenum_t.S_PLAY_RUN2
      return 151
    end case
    case statenum_t.S_PLAY_RUN3
      return 152
    end case
    case statenum_t.S_PLAY_RUN4
      return 153
    end case
    case statenum_t.S_PLAY_ATK1
      return 154
    end case
    case statenum_t.S_PLAY_ATK2
      return 155
    end case
    case statenum_t.S_PLAY_PAIN
      return 156
    end case
    case statenum_t.S_PLAY_PAIN2
      return 157
    end case
    case statenum_t.S_PLAY_DIE1
      return 158
    end case
    case statenum_t.S_PLAY_DIE2
      return 159
    end case
    case statenum_t.S_PLAY_DIE3
      return 160
    end case
    case statenum_t.S_PLAY_DIE4
      return 161
    end case
    case statenum_t.S_PLAY_DIE5
      return 162
    end case
    case statenum_t.S_PLAY_DIE6
      return 163
    end case
    case statenum_t.S_PLAY_DIE7
      return 164
    end case
    case statenum_t.S_PLAY_XDIE1
      return 165
    end case
    case statenum_t.S_PLAY_XDIE2
      return 166
    end case
    case statenum_t.S_PLAY_XDIE3
      return 167
    end case
    case statenum_t.S_PLAY_XDIE4
      return 168
    end case
    case statenum_t.S_PLAY_XDIE5
      return 169
    end case
    case statenum_t.S_PLAY_XDIE6
      return 170
    end case
    case statenum_t.S_PLAY_XDIE7
      return 171
    end case
    case statenum_t.S_PLAY_XDIE8
      return 172
    end case
    case statenum_t.S_PLAY_XDIE9
      return 173
    end case
    case statenum_t.S_POSS_STND
      return 174
    end case
    case statenum_t.S_POSS_STND2
      return 175
    end case
    case statenum_t.S_POSS_RUN1
      return 176
    end case
    case statenum_t.S_POSS_RUN2
      return 177
    end case
    case statenum_t.S_POSS_RUN3
      return 178
    end case
    case statenum_t.S_POSS_RUN4
      return 179
    end case
    case statenum_t.S_POSS_RUN5
      return 180
    end case
    case statenum_t.S_POSS_RUN6
      return 181
    end case
    case statenum_t.S_POSS_RUN7
      return 182
    end case
    case statenum_t.S_POSS_RUN8
      return 183
    end case
    case statenum_t.S_POSS_ATK1
      return 184
    end case
    case statenum_t.S_POSS_ATK2
      return 185
    end case
    case statenum_t.S_POSS_ATK3
      return 186
    end case
    case statenum_t.S_POSS_PAIN
      return 187
    end case
    case statenum_t.S_POSS_PAIN2
      return 188
    end case
    case statenum_t.S_POSS_DIE1
      return 189
    end case
    case statenum_t.S_POSS_DIE2
      return 190
    end case
    case statenum_t.S_POSS_DIE3
      return 191
    end case
    case statenum_t.S_POSS_DIE4
      return 192
    end case
    case statenum_t.S_POSS_DIE5
      return 193
    end case
    case statenum_t.S_POSS_XDIE1
      return 194
    end case
    case statenum_t.S_POSS_XDIE2
      return 195
    end case
    case statenum_t.S_POSS_XDIE3
      return 196
    end case
    case statenum_t.S_POSS_XDIE4
      return 197
    end case
    case statenum_t.S_POSS_XDIE5
      return 198
    end case
    case statenum_t.S_POSS_XDIE6
      return 199
    end case
    case statenum_t.S_POSS_XDIE7
      return 200
    end case
    case statenum_t.S_POSS_XDIE8
      return 201
    end case
    case statenum_t.S_POSS_XDIE9
      return 202
    end case
    case statenum_t.S_POSS_RAISE1
      return 203
    end case
    case statenum_t.S_POSS_RAISE2
      return 204
    end case
    case statenum_t.S_POSS_RAISE3
      return 205
    end case
    case statenum_t.S_POSS_RAISE4
      return 206
    end case
    case statenum_t.S_SPOS_STND
      return 207
    end case
    case statenum_t.S_SPOS_STND2
      return 208
    end case
    case statenum_t.S_SPOS_RUN1
      return 209
    end case
    case statenum_t.S_SPOS_RUN2
      return 210
    end case
    case statenum_t.S_SPOS_RUN3
      return 211
    end case
    case statenum_t.S_SPOS_RUN4
      return 212
    end case
    case statenum_t.S_SPOS_RUN5
      return 213
    end case
    case statenum_t.S_SPOS_RUN6
      return 214
    end case
    case statenum_t.S_SPOS_RUN7
      return 215
    end case
    case statenum_t.S_SPOS_RUN8
      return 216
    end case
    case statenum_t.S_SPOS_ATK1
      return 217
    end case
    case statenum_t.S_SPOS_ATK2
      return 218
    end case
    case statenum_t.S_SPOS_ATK3
      return 219
    end case
    case statenum_t.S_SPOS_PAIN
      return 220
    end case
    case statenum_t.S_SPOS_PAIN2
      return 221
    end case
    case statenum_t.S_SPOS_DIE1
      return 222
    end case
    case statenum_t.S_SPOS_DIE2
      return 223
    end case
    case statenum_t.S_SPOS_DIE3
      return 224
    end case
    case statenum_t.S_SPOS_DIE4
      return 225
    end case
    case statenum_t.S_SPOS_DIE5
      return 226
    end case
    case statenum_t.S_SPOS_XDIE1
      return 227
    end case
    case statenum_t.S_SPOS_XDIE2
      return 228
    end case
    case statenum_t.S_SPOS_XDIE3
      return 229
    end case
    case statenum_t.S_SPOS_XDIE4
      return 230
    end case
    case statenum_t.S_SPOS_XDIE5
      return 231
    end case
    case statenum_t.S_SPOS_XDIE6
      return 232
    end case
    case statenum_t.S_SPOS_XDIE7
      return 233
    end case
    case statenum_t.S_SPOS_XDIE8
      return 234
    end case
    case statenum_t.S_SPOS_XDIE9
      return 235
    end case
    case statenum_t.S_SPOS_RAISE1
      return 236
    end case
    case statenum_t.S_SPOS_RAISE2
      return 237
    end case
    case statenum_t.S_SPOS_RAISE3
      return 238
    end case
    case statenum_t.S_SPOS_RAISE4
      return 239
    end case
    case statenum_t.S_SPOS_RAISE5
      return 240
    end case
    case statenum_t.S_VILE_STND
      return 241
    end case
    case statenum_t.S_VILE_STND2
      return 242
    end case
    case statenum_t.S_VILE_RUN1
      return 243
    end case
    case statenum_t.S_VILE_RUN2
      return 244
    end case
    case statenum_t.S_VILE_RUN3
      return 245
    end case
    case statenum_t.S_VILE_RUN4
      return 246
    end case
    case statenum_t.S_VILE_RUN5
      return 247
    end case
    case statenum_t.S_VILE_RUN6
      return 248
    end case
    case statenum_t.S_VILE_RUN7
      return 249
    end case
    case statenum_t.S_VILE_RUN8
      return 250
    end case
    case statenum_t.S_VILE_RUN9
      return 251
    end case
    case statenum_t.S_VILE_RUN10
      return 252
    end case
    case statenum_t.S_VILE_RUN11
      return 253
    end case
    case statenum_t.S_VILE_RUN12
      return 254
    end case
    case statenum_t.S_VILE_ATK1
      return 255
    end case
    case statenum_t.S_VILE_ATK2
      return 256
    end case
    case statenum_t.S_VILE_ATK3
      return 257
    end case
    case statenum_t.S_VILE_ATK4
      return 258
    end case
    case statenum_t.S_VILE_ATK5
      return 259
    end case
    case statenum_t.S_VILE_ATK6
      return 260
    end case
    case statenum_t.S_VILE_ATK7
      return 261
    end case
    case statenum_t.S_VILE_ATK8
      return 262
    end case
    case statenum_t.S_VILE_ATK9
      return 263
    end case
    case statenum_t.S_VILE_ATK10
      return 264
    end case
    case statenum_t.S_VILE_ATK11
      return 265
    end case
    case statenum_t.S_VILE_HEAL1
      return 266
    end case
    case statenum_t.S_VILE_HEAL2
      return 267
    end case
    case statenum_t.S_VILE_HEAL3
      return 268
    end case
    case statenum_t.S_VILE_PAIN
      return 269
    end case
    case statenum_t.S_VILE_PAIN2
      return 270
    end case
    case statenum_t.S_VILE_DIE1
      return 271
    end case
    case statenum_t.S_VILE_DIE2
      return 272
    end case
    case statenum_t.S_VILE_DIE3
      return 273
    end case
    case statenum_t.S_VILE_DIE4
      return 274
    end case
    case statenum_t.S_VILE_DIE5
      return 275
    end case
    case statenum_t.S_VILE_DIE6
      return 276
    end case
    case statenum_t.S_VILE_DIE7
      return 277
    end case
    case statenum_t.S_VILE_DIE8
      return 278
    end case
    case statenum_t.S_VILE_DIE9
      return 279
    end case
    case statenum_t.S_VILE_DIE10
      return 280
    end case
    case statenum_t.S_FIRE1
      return 281
    end case
    case statenum_t.S_FIRE2
      return 282
    end case
    case statenum_t.S_FIRE3
      return 283
    end case
    case statenum_t.S_FIRE4
      return 284
    end case
    case statenum_t.S_FIRE5
      return 285
    end case
    case statenum_t.S_FIRE6
      return 286
    end case
    case statenum_t.S_FIRE7
      return 287
    end case
    case statenum_t.S_FIRE8
      return 288
    end case
    case statenum_t.S_FIRE9
      return 289
    end case
    case statenum_t.S_FIRE10
      return 290
    end case
    case statenum_t.S_FIRE11
      return 291
    end case
    case statenum_t.S_FIRE12
      return 292
    end case
    case statenum_t.S_FIRE13
      return 293
    end case
    case statenum_t.S_FIRE14
      return 294
    end case
    case statenum_t.S_FIRE15
      return 295
    end case
    case statenum_t.S_FIRE16
      return 296
    end case
    case statenum_t.S_FIRE17
      return 297
    end case
    case statenum_t.S_FIRE18
      return 298
    end case
    case statenum_t.S_FIRE19
      return 299
    end case
    case statenum_t.S_FIRE20
      return 300
    end case
    case statenum_t.S_FIRE21
      return 301
    end case
    case statenum_t.S_FIRE22
      return 302
    end case
    case statenum_t.S_FIRE23
      return 303
    end case
    case statenum_t.S_FIRE24
      return 304
    end case
    case statenum_t.S_FIRE25
      return 305
    end case
    case statenum_t.S_FIRE26
      return 306
    end case
    case statenum_t.S_FIRE27
      return 307
    end case
    case statenum_t.S_FIRE28
      return 308
    end case
    case statenum_t.S_FIRE29
      return 309
    end case
    case statenum_t.S_FIRE30
      return 310
    end case
    case statenum_t.S_SMOKE1
      return 311
    end case
    case statenum_t.S_SMOKE2
      return 312
    end case
    case statenum_t.S_SMOKE3
      return 313
    end case
    case statenum_t.S_SMOKE4
      return 314
    end case
    case statenum_t.S_SMOKE5
      return 315
    end case
    case statenum_t.S_TRACER
      return 316
    end case
    case statenum_t.S_TRACER2
      return 317
    end case
    case statenum_t.S_TRACEEXP1
      return 318
    end case
    case statenum_t.S_TRACEEXP2
      return 319
    end case
    case statenum_t.S_TRACEEXP3
      return 320
    end case
    case statenum_t.S_SKEL_STND
      return 321
    end case
    case statenum_t.S_SKEL_STND2
      return 322
    end case
    case statenum_t.S_SKEL_RUN1
      return 323
    end case
    case statenum_t.S_SKEL_RUN2
      return 324
    end case
    case statenum_t.S_SKEL_RUN3
      return 325
    end case
    case statenum_t.S_SKEL_RUN4
      return 326
    end case
    case statenum_t.S_SKEL_RUN5
      return 327
    end case
    case statenum_t.S_SKEL_RUN6
      return 328
    end case
    case statenum_t.S_SKEL_RUN7
      return 329
    end case
    case statenum_t.S_SKEL_RUN8
      return 330
    end case
    case statenum_t.S_SKEL_RUN9
      return 331
    end case
    case statenum_t.S_SKEL_RUN10
      return 332
    end case
    case statenum_t.S_SKEL_RUN11
      return 333
    end case
    case statenum_t.S_SKEL_RUN12
      return 334
    end case
    case statenum_t.S_SKEL_FIST1
      return 335
    end case
    case statenum_t.S_SKEL_FIST2
      return 336
    end case
    case statenum_t.S_SKEL_FIST3
      return 337
    end case
    case statenum_t.S_SKEL_FIST4
      return 338
    end case
    case statenum_t.S_SKEL_MISS1
      return 339
    end case
    case statenum_t.S_SKEL_MISS2
      return 340
    end case
    case statenum_t.S_SKEL_MISS3
      return 341
    end case
    case statenum_t.S_SKEL_MISS4
      return 342
    end case
    case statenum_t.S_SKEL_PAIN
      return 343
    end case
    case statenum_t.S_SKEL_PAIN2
      return 344
    end case
    case statenum_t.S_SKEL_DIE1
      return 345
    end case
    case statenum_t.S_SKEL_DIE2
      return 346
    end case
    case statenum_t.S_SKEL_DIE3
      return 347
    end case
    case statenum_t.S_SKEL_DIE4
      return 348
    end case
    case statenum_t.S_SKEL_DIE5
      return 349
    end case
    case statenum_t.S_SKEL_DIE6
      return 350
    end case
    case statenum_t.S_SKEL_RAISE1
      return 351
    end case
    case statenum_t.S_SKEL_RAISE2
      return 352
    end case
    case statenum_t.S_SKEL_RAISE3
      return 353
    end case
    case statenum_t.S_SKEL_RAISE4
      return 354
    end case
    case statenum_t.S_SKEL_RAISE5
      return 355
    end case
    case statenum_t.S_SKEL_RAISE6
      return 356
    end case
    case statenum_t.S_FATSHOT1
      return 357
    end case
    case statenum_t.S_FATSHOT2
      return 358
    end case
    case statenum_t.S_FATSHOTX1
      return 359
    end case
    case statenum_t.S_FATSHOTX2
      return 360
    end case
    case statenum_t.S_FATSHOTX3
      return 361
    end case
    case statenum_t.S_FATT_STND
      return 362
    end case
    case statenum_t.S_FATT_STND2
      return 363
    end case
    case statenum_t.S_FATT_RUN1
      return 364
    end case
    case statenum_t.S_FATT_RUN2
      return 365
    end case
    case statenum_t.S_FATT_RUN3
      return 366
    end case
    case statenum_t.S_FATT_RUN4
      return 367
    end case
    case statenum_t.S_FATT_RUN5
      return 368
    end case
    case statenum_t.S_FATT_RUN6
      return 369
    end case
    case statenum_t.S_FATT_RUN7
      return 370
    end case
    case statenum_t.S_FATT_RUN8
      return 371
    end case
    case statenum_t.S_FATT_RUN9
      return 372
    end case
    case statenum_t.S_FATT_RUN10
      return 373
    end case
    case statenum_t.S_FATT_RUN11
      return 374
    end case
    case statenum_t.S_FATT_RUN12
      return 375
    end case
    case statenum_t.S_FATT_ATK1
      return 376
    end case
    case statenum_t.S_FATT_ATK2
      return 377
    end case
    case statenum_t.S_FATT_ATK3
      return 378
    end case
    case statenum_t.S_FATT_ATK4
      return 379
    end case
    case statenum_t.S_FATT_ATK5
      return 380
    end case
    case statenum_t.S_FATT_ATK6
      return 381
    end case
    case statenum_t.S_FATT_ATK7
      return 382
    end case
    case statenum_t.S_FATT_ATK8
      return 383
    end case
    case statenum_t.S_FATT_ATK9
      return 384
    end case
    case statenum_t.S_FATT_ATK10
      return 385
    end case
    case statenum_t.S_FATT_PAIN
      return 386
    end case
    case statenum_t.S_FATT_PAIN2
      return 387
    end case
    case statenum_t.S_FATT_DIE1
      return 388
    end case
    case statenum_t.S_FATT_DIE2
      return 389
    end case
    case statenum_t.S_FATT_DIE3
      return 390
    end case
    case statenum_t.S_FATT_DIE4
      return 391
    end case
    case statenum_t.S_FATT_DIE5
      return 392
    end case
    case statenum_t.S_FATT_DIE6
      return 393
    end case
    case statenum_t.S_FATT_DIE7
      return 394
    end case
    case statenum_t.S_FATT_DIE8
      return 395
    end case
    case statenum_t.S_FATT_DIE9
      return 396
    end case
    case statenum_t.S_FATT_DIE10
      return 397
    end case
    case statenum_t.S_FATT_RAISE1
      return 398
    end case
    case statenum_t.S_FATT_RAISE2
      return 399
    end case
    case statenum_t.S_FATT_RAISE3
      return 400
    end case
    case statenum_t.S_FATT_RAISE4
      return 401
    end case
    case statenum_t.S_FATT_RAISE5
      return 402
    end case
    case statenum_t.S_FATT_RAISE6
      return 403
    end case
    case statenum_t.S_FATT_RAISE7
      return 404
    end case
    case statenum_t.S_FATT_RAISE8
      return 405
    end case
    case statenum_t.S_CPOS_STND
      return 406
    end case
    case statenum_t.S_CPOS_STND2
      return 407
    end case
    case statenum_t.S_CPOS_RUN1
      return 408
    end case
    case statenum_t.S_CPOS_RUN2
      return 409
    end case
    case statenum_t.S_CPOS_RUN3
      return 410
    end case
    case statenum_t.S_CPOS_RUN4
      return 411
    end case
    case statenum_t.S_CPOS_RUN5
      return 412
    end case
    case statenum_t.S_CPOS_RUN6
      return 413
    end case
    case statenum_t.S_CPOS_RUN7
      return 414
    end case
    case statenum_t.S_CPOS_RUN8
      return 415
    end case
    case statenum_t.S_CPOS_ATK1
      return 416
    end case
    case statenum_t.S_CPOS_ATK2
      return 417
    end case
    case statenum_t.S_CPOS_ATK3
      return 418
    end case
    case statenum_t.S_CPOS_ATK4
      return 419
    end case
    case statenum_t.S_CPOS_PAIN
      return 420
    end case
    case statenum_t.S_CPOS_PAIN2
      return 421
    end case
    case statenum_t.S_CPOS_DIE1
      return 422
    end case
    case statenum_t.S_CPOS_DIE2
      return 423
    end case
    case statenum_t.S_CPOS_DIE3
      return 424
    end case
    case statenum_t.S_CPOS_DIE4
      return 425
    end case
    case statenum_t.S_CPOS_DIE5
      return 426
    end case
    case statenum_t.S_CPOS_DIE6
      return 427
    end case
    case statenum_t.S_CPOS_DIE7
      return 428
    end case
    case statenum_t.S_CPOS_XDIE1
      return 429
    end case
    case statenum_t.S_CPOS_XDIE2
      return 430
    end case
    case statenum_t.S_CPOS_XDIE3
      return 431
    end case
    case statenum_t.S_CPOS_XDIE4
      return 432
    end case
    case statenum_t.S_CPOS_XDIE5
      return 433
    end case
    case statenum_t.S_CPOS_XDIE6
      return 434
    end case
    case statenum_t.S_CPOS_RAISE1
      return 435
    end case
    case statenum_t.S_CPOS_RAISE2
      return 436
    end case
    case statenum_t.S_CPOS_RAISE3
      return 437
    end case
    case statenum_t.S_CPOS_RAISE4
      return 438
    end case
    case statenum_t.S_CPOS_RAISE5
      return 439
    end case
    case statenum_t.S_CPOS_RAISE6
      return 440
    end case
    case statenum_t.S_CPOS_RAISE7
      return 441
    end case
    case statenum_t.S_TROO_STND
      return 442
    end case
    case statenum_t.S_TROO_STND2
      return 443
    end case
    case statenum_t.S_TROO_RUN1
      return 444
    end case
    case statenum_t.S_TROO_RUN2
      return 445
    end case
    case statenum_t.S_TROO_RUN3
      return 446
    end case
    case statenum_t.S_TROO_RUN4
      return 447
    end case
    case statenum_t.S_TROO_RUN5
      return 448
    end case
    case statenum_t.S_TROO_RUN6
      return 449
    end case
    case statenum_t.S_TROO_RUN7
      return 450
    end case
    case statenum_t.S_TROO_RUN8
      return 451
    end case
    case statenum_t.S_TROO_ATK1
      return 452
    end case
    case statenum_t.S_TROO_ATK2
      return 453
    end case
    case statenum_t.S_TROO_ATK3
      return 454
    end case
    case statenum_t.S_TROO_PAIN
      return 455
    end case
    case statenum_t.S_TROO_PAIN2
      return 456
    end case
    case statenum_t.S_TROO_DIE1
      return 457
    end case
    case statenum_t.S_TROO_DIE2
      return 458
    end case
    case statenum_t.S_TROO_DIE3
      return 459
    end case
    case statenum_t.S_TROO_DIE4
      return 460
    end case
    case statenum_t.S_TROO_DIE5
      return 461
    end case
    case statenum_t.S_TROO_XDIE1
      return 462
    end case
    case statenum_t.S_TROO_XDIE2
      return 463
    end case
    case statenum_t.S_TROO_XDIE3
      return 464
    end case
    case statenum_t.S_TROO_XDIE4
      return 465
    end case
    case statenum_t.S_TROO_XDIE5
      return 466
    end case
    case statenum_t.S_TROO_XDIE6
      return 467
    end case
    case statenum_t.S_TROO_XDIE7
      return 468
    end case
    case statenum_t.S_TROO_XDIE8
      return 469
    end case
    case statenum_t.S_TROO_RAISE1
      return 470
    end case
    case statenum_t.S_TROO_RAISE2
      return 471
    end case
    case statenum_t.S_TROO_RAISE3
      return 472
    end case
    case statenum_t.S_TROO_RAISE4
      return 473
    end case
    case statenum_t.S_TROO_RAISE5
      return 474
    end case
    case statenum_t.S_SARG_STND
      return 475
    end case
    case statenum_t.S_SARG_STND2
      return 476
    end case
    case statenum_t.S_SARG_RUN1
      return 477
    end case
    case statenum_t.S_SARG_RUN2
      return 478
    end case
    case statenum_t.S_SARG_RUN3
      return 479
    end case
    case statenum_t.S_SARG_RUN4
      return 480
    end case
    case statenum_t.S_SARG_RUN5
      return 481
    end case
    case statenum_t.S_SARG_RUN6
      return 482
    end case
    case statenum_t.S_SARG_RUN7
      return 483
    end case
    case statenum_t.S_SARG_RUN8
      return 484
    end case
    case statenum_t.S_SARG_ATK1
      return 485
    end case
    case statenum_t.S_SARG_ATK2
      return 486
    end case
    case statenum_t.S_SARG_ATK3
      return 487
    end case
    case statenum_t.S_SARG_PAIN
      return 488
    end case
    case statenum_t.S_SARG_PAIN2
      return 489
    end case
    case statenum_t.S_SARG_DIE1
      return 490
    end case
    case statenum_t.S_SARG_DIE2
      return 491
    end case
    case statenum_t.S_SARG_DIE3
      return 492
    end case
    case statenum_t.S_SARG_DIE4
      return 493
    end case
    case statenum_t.S_SARG_DIE5
      return 494
    end case
    case statenum_t.S_SARG_DIE6
      return 495
    end case
    case statenum_t.S_SARG_RAISE1
      return 496
    end case
    case statenum_t.S_SARG_RAISE2
      return 497
    end case
    case statenum_t.S_SARG_RAISE3
      return 498
    end case
    case statenum_t.S_SARG_RAISE4
      return 499
    end case
    case statenum_t.S_SARG_RAISE5
      return 500
    end case
    case statenum_t.S_SARG_RAISE6
      return 501
    end case
    case statenum_t.S_HEAD_STND
      return 502
    end case
    case statenum_t.S_HEAD_RUN1
      return 503
    end case
    case statenum_t.S_HEAD_ATK1
      return 504
    end case
    case statenum_t.S_HEAD_ATK2
      return 505
    end case
    case statenum_t.S_HEAD_ATK3
      return 506
    end case
    case statenum_t.S_HEAD_PAIN
      return 507
    end case
    case statenum_t.S_HEAD_PAIN2
      return 508
    end case
    case statenum_t.S_HEAD_PAIN3
      return 509
    end case
    case statenum_t.S_HEAD_DIE1
      return 510
    end case
    case statenum_t.S_HEAD_DIE2
      return 511
    end case
    case statenum_t.S_HEAD_DIE3
      return 512
    end case
    case statenum_t.S_HEAD_DIE4
      return 513
    end case
    case statenum_t.S_HEAD_DIE5
      return 514
    end case
    case statenum_t.S_HEAD_DIE6
      return 515
    end case
    case statenum_t.S_HEAD_RAISE1
      return 516
    end case
    case statenum_t.S_HEAD_RAISE2
      return 517
    end case
    case statenum_t.S_HEAD_RAISE3
      return 518
    end case
    case statenum_t.S_HEAD_RAISE4
      return 519
    end case
    case statenum_t.S_HEAD_RAISE5
      return 520
    end case
    case statenum_t.S_HEAD_RAISE6
      return 521
    end case
    case statenum_t.S_BRBALL1
      return 522
    end case
    case statenum_t.S_BRBALL2
      return 523
    end case
    case statenum_t.S_BRBALLX1
      return 524
    end case
    case statenum_t.S_BRBALLX2
      return 525
    end case
    case statenum_t.S_BRBALLX3
      return 526
    end case
    case statenum_t.S_BOSS_STND
      return 527
    end case
    case statenum_t.S_BOSS_STND2
      return 528
    end case
    case statenum_t.S_BOSS_RUN1
      return 529
    end case
    case statenum_t.S_BOSS_RUN2
      return 530
    end case
    case statenum_t.S_BOSS_RUN3
      return 531
    end case
    case statenum_t.S_BOSS_RUN4
      return 532
    end case
    case statenum_t.S_BOSS_RUN5
      return 533
    end case
    case statenum_t.S_BOSS_RUN6
      return 534
    end case
    case statenum_t.S_BOSS_RUN7
      return 535
    end case
    case statenum_t.S_BOSS_RUN8
      return 536
    end case
    case statenum_t.S_BOSS_ATK1
      return 537
    end case
    case statenum_t.S_BOSS_ATK2
      return 538
    end case
    case statenum_t.S_BOSS_ATK3
      return 539
    end case
    case statenum_t.S_BOSS_PAIN
      return 540
    end case
    case statenum_t.S_BOSS_PAIN2
      return 541
    end case
    case statenum_t.S_BOSS_DIE1
      return 542
    end case
    case statenum_t.S_BOSS_DIE2
      return 543
    end case
    case statenum_t.S_BOSS_DIE3
      return 544
    end case
    case statenum_t.S_BOSS_DIE4
      return 545
    end case
    case statenum_t.S_BOSS_DIE5
      return 546
    end case
    case statenum_t.S_BOSS_DIE6
      return 547
    end case
    case statenum_t.S_BOSS_DIE7
      return 548
    end case
    case statenum_t.S_BOSS_RAISE1
      return 549
    end case
    case statenum_t.S_BOSS_RAISE2
      return 550
    end case
    case statenum_t.S_BOSS_RAISE3
      return 551
    end case
    case statenum_t.S_BOSS_RAISE4
      return 552
    end case
    case statenum_t.S_BOSS_RAISE5
      return 553
    end case
    case statenum_t.S_BOSS_RAISE6
      return 554
    end case
    case statenum_t.S_BOSS_RAISE7
      return 555
    end case
    case statenum_t.S_BOS2_STND
      return 556
    end case
    case statenum_t.S_BOS2_STND2
      return 557
    end case
    case statenum_t.S_BOS2_RUN1
      return 558
    end case
    case statenum_t.S_BOS2_RUN2
      return 559
    end case
    case statenum_t.S_BOS2_RUN3
      return 560
    end case
    case statenum_t.S_BOS2_RUN4
      return 561
    end case
    case statenum_t.S_BOS2_RUN5
      return 562
    end case
    case statenum_t.S_BOS2_RUN6
      return 563
    end case
    case statenum_t.S_BOS2_RUN7
      return 564
    end case
    case statenum_t.S_BOS2_RUN8
      return 565
    end case
    case statenum_t.S_BOS2_ATK1
      return 566
    end case
    case statenum_t.S_BOS2_ATK2
      return 567
    end case
    case statenum_t.S_BOS2_ATK3
      return 568
    end case
    case statenum_t.S_BOS2_PAIN
      return 569
    end case
    case statenum_t.S_BOS2_PAIN2
      return 570
    end case
    case statenum_t.S_BOS2_DIE1
      return 571
    end case
    case statenum_t.S_BOS2_DIE2
      return 572
    end case
    case statenum_t.S_BOS2_DIE3
      return 573
    end case
    case statenum_t.S_BOS2_DIE4
      return 574
    end case
    case statenum_t.S_BOS2_DIE5
      return 575
    end case
    case statenum_t.S_BOS2_DIE6
      return 576
    end case
    case statenum_t.S_BOS2_DIE7
      return 577
    end case
    case statenum_t.S_BOS2_RAISE1
      return 578
    end case
    case statenum_t.S_BOS2_RAISE2
      return 579
    end case
    case statenum_t.S_BOS2_RAISE3
      return 580
    end case
    case statenum_t.S_BOS2_RAISE4
      return 581
    end case
    case statenum_t.S_BOS2_RAISE5
      return 582
    end case
    case statenum_t.S_BOS2_RAISE6
      return 583
    end case
    case statenum_t.S_BOS2_RAISE7
      return 584
    end case
    case statenum_t.S_SKULL_STND
      return 585
    end case
    case statenum_t.S_SKULL_STND2
      return 586
    end case
    case statenum_t.S_SKULL_RUN1
      return 587
    end case
    case statenum_t.S_SKULL_RUN2
      return 588
    end case
    case statenum_t.S_SKULL_ATK1
      return 589
    end case
    case statenum_t.S_SKULL_ATK2
      return 590
    end case
    case statenum_t.S_SKULL_ATK3
      return 591
    end case
    case statenum_t.S_SKULL_ATK4
      return 592
    end case
    case statenum_t.S_SKULL_PAIN
      return 593
    end case
    case statenum_t.S_SKULL_PAIN2
      return 594
    end case
    case statenum_t.S_SKULL_DIE1
      return 595
    end case
    case statenum_t.S_SKULL_DIE2
      return 596
    end case
    case statenum_t.S_SKULL_DIE3
      return 597
    end case
    case statenum_t.S_SKULL_DIE4
      return 598
    end case
    case statenum_t.S_SKULL_DIE5
      return 599
    end case
    case statenum_t.S_SKULL_DIE6
      return 600
    end case
    case statenum_t.S_SPID_STND
      return 601
    end case
    case statenum_t.S_SPID_STND2
      return 602
    end case
    case statenum_t.S_SPID_RUN1
      return 603
    end case
    case statenum_t.S_SPID_RUN2
      return 604
    end case
    case statenum_t.S_SPID_RUN3
      return 605
    end case
    case statenum_t.S_SPID_RUN4
      return 606
    end case
    case statenum_t.S_SPID_RUN5
      return 607
    end case
    case statenum_t.S_SPID_RUN6
      return 608
    end case
    case statenum_t.S_SPID_RUN7
      return 609
    end case
    case statenum_t.S_SPID_RUN8
      return 610
    end case
    case statenum_t.S_SPID_RUN9
      return 611
    end case
    case statenum_t.S_SPID_RUN10
      return 612
    end case
    case statenum_t.S_SPID_RUN11
      return 613
    end case
    case statenum_t.S_SPID_RUN12
      return 614
    end case
    case statenum_t.S_SPID_ATK1
      return 615
    end case
    case statenum_t.S_SPID_ATK2
      return 616
    end case
    case statenum_t.S_SPID_ATK3
      return 617
    end case
    case statenum_t.S_SPID_ATK4
      return 618
    end case
    case statenum_t.S_SPID_PAIN
      return 619
    end case
    case statenum_t.S_SPID_PAIN2
      return 620
    end case
    case statenum_t.S_SPID_DIE1
      return 621
    end case
    case statenum_t.S_SPID_DIE2
      return 622
    end case
    case statenum_t.S_SPID_DIE3
      return 623
    end case
    case statenum_t.S_SPID_DIE4
      return 624
    end case
    case statenum_t.S_SPID_DIE5
      return 625
    end case
    case statenum_t.S_SPID_DIE6
      return 626
    end case
    case statenum_t.S_SPID_DIE7
      return 627
    end case
    case statenum_t.S_SPID_DIE8
      return 628
    end case
    case statenum_t.S_SPID_DIE9
      return 629
    end case
    case statenum_t.S_SPID_DIE10
      return 630
    end case
    case statenum_t.S_SPID_DIE11
      return 631
    end case
    case statenum_t.S_BSPI_STND
      return 632
    end case
    case statenum_t.S_BSPI_STND2
      return 633
    end case
    case statenum_t.S_BSPI_SIGHT
      return 634
    end case
    case statenum_t.S_BSPI_RUN1
      return 635
    end case
    case statenum_t.S_BSPI_RUN2
      return 636
    end case
    case statenum_t.S_BSPI_RUN3
      return 637
    end case
    case statenum_t.S_BSPI_RUN4
      return 638
    end case
    case statenum_t.S_BSPI_RUN5
      return 639
    end case
    case statenum_t.S_BSPI_RUN6
      return 640
    end case
    case statenum_t.S_BSPI_RUN7
      return 641
    end case
    case statenum_t.S_BSPI_RUN8
      return 642
    end case
    case statenum_t.S_BSPI_RUN9
      return 643
    end case
    case statenum_t.S_BSPI_RUN10
      return 644
    end case
    case statenum_t.S_BSPI_RUN11
      return 645
    end case
    case statenum_t.S_BSPI_RUN12
      return 646
    end case
    case statenum_t.S_BSPI_ATK1
      return 647
    end case
    case statenum_t.S_BSPI_ATK2
      return 648
    end case
    case statenum_t.S_BSPI_ATK3
      return 649
    end case
    case statenum_t.S_BSPI_ATK4
      return 650
    end case
    case statenum_t.S_BSPI_PAIN
      return 651
    end case
    case statenum_t.S_BSPI_PAIN2
      return 652
    end case
    case statenum_t.S_BSPI_DIE1
      return 653
    end case
    case statenum_t.S_BSPI_DIE2
      return 654
    end case
    case statenum_t.S_BSPI_DIE3
      return 655
    end case
    case statenum_t.S_BSPI_DIE4
      return 656
    end case
    case statenum_t.S_BSPI_DIE5
      return 657
    end case
    case statenum_t.S_BSPI_DIE6
      return 658
    end case
    case statenum_t.S_BSPI_DIE7
      return 659
    end case
    case statenum_t.S_BSPI_RAISE1
      return 660
    end case
    case statenum_t.S_BSPI_RAISE2
      return 661
    end case
    case statenum_t.S_BSPI_RAISE3
      return 662
    end case
    case statenum_t.S_BSPI_RAISE4
      return 663
    end case
    case statenum_t.S_BSPI_RAISE5
      return 664
    end case
    case statenum_t.S_BSPI_RAISE6
      return 665
    end case
    case statenum_t.S_BSPI_RAISE7
      return 666
    end case
    case statenum_t.S_ARACH_PLAZ
      return 667
    end case
    case statenum_t.S_ARACH_PLAZ2
      return 668
    end case
    case statenum_t.S_ARACH_PLEX
      return 669
    end case
    case statenum_t.S_ARACH_PLEX2
      return 670
    end case
    case statenum_t.S_ARACH_PLEX3
      return 671
    end case
    case statenum_t.S_ARACH_PLEX4
      return 672
    end case
    case statenum_t.S_ARACH_PLEX5
      return 673
    end case
    case statenum_t.S_CYBER_STND
      return 674
    end case
    case statenum_t.S_CYBER_STND2
      return 675
    end case
    case statenum_t.S_CYBER_RUN1
      return 676
    end case
    case statenum_t.S_CYBER_RUN2
      return 677
    end case
    case statenum_t.S_CYBER_RUN3
      return 678
    end case
    case statenum_t.S_CYBER_RUN4
      return 679
    end case
    case statenum_t.S_CYBER_RUN5
      return 680
    end case
    case statenum_t.S_CYBER_RUN6
      return 681
    end case
    case statenum_t.S_CYBER_RUN7
      return 682
    end case
    case statenum_t.S_CYBER_RUN8
      return 683
    end case
    case statenum_t.S_CYBER_ATK1
      return 684
    end case
    case statenum_t.S_CYBER_ATK2
      return 685
    end case
    case statenum_t.S_CYBER_ATK3
      return 686
    end case
    case statenum_t.S_CYBER_ATK4
      return 687
    end case
    case statenum_t.S_CYBER_ATK5
      return 688
    end case
    case statenum_t.S_CYBER_ATK6
      return 689
    end case
    case statenum_t.S_CYBER_PAIN
      return 690
    end case
    case statenum_t.S_CYBER_DIE1
      return 691
    end case
    case statenum_t.S_CYBER_DIE2
      return 692
    end case
    case statenum_t.S_CYBER_DIE3
      return 693
    end case
    case statenum_t.S_CYBER_DIE4
      return 694
    end case
    case statenum_t.S_CYBER_DIE5
      return 695
    end case
    case statenum_t.S_CYBER_DIE6
      return 696
    end case
    case statenum_t.S_CYBER_DIE7
      return 697
    end case
    case statenum_t.S_CYBER_DIE8
      return 698
    end case
    case statenum_t.S_CYBER_DIE9
      return 699
    end case
    case statenum_t.S_CYBER_DIE10
      return 700
    end case
    case statenum_t.S_PAIN_STND
      return 701
    end case
    case statenum_t.S_PAIN_RUN1
      return 702
    end case
    case statenum_t.S_PAIN_RUN2
      return 703
    end case
    case statenum_t.S_PAIN_RUN3
      return 704
    end case
    case statenum_t.S_PAIN_RUN4
      return 705
    end case
    case statenum_t.S_PAIN_RUN5
      return 706
    end case
    case statenum_t.S_PAIN_RUN6
      return 707
    end case
    case statenum_t.S_PAIN_ATK1
      return 708
    end case
    case statenum_t.S_PAIN_ATK2
      return 709
    end case
    case statenum_t.S_PAIN_ATK3
      return 710
    end case
    case statenum_t.S_PAIN_ATK4
      return 711
    end case
    case statenum_t.S_PAIN_PAIN
      return 712
    end case
    case statenum_t.S_PAIN_PAIN2
      return 713
    end case
    case statenum_t.S_PAIN_DIE1
      return 714
    end case
    case statenum_t.S_PAIN_DIE2
      return 715
    end case
    case statenum_t.S_PAIN_DIE3
      return 716
    end case
    case statenum_t.S_PAIN_DIE4
      return 717
    end case
    case statenum_t.S_PAIN_DIE5
      return 718
    end case
    case statenum_t.S_PAIN_DIE6
      return 719
    end case
    case statenum_t.S_PAIN_RAISE1
      return 720
    end case
    case statenum_t.S_PAIN_RAISE2
      return 721
    end case
    case statenum_t.S_PAIN_RAISE3
      return 722
    end case
    case statenum_t.S_PAIN_RAISE4
      return 723
    end case
    case statenum_t.S_PAIN_RAISE5
      return 724
    end case
    case statenum_t.S_PAIN_RAISE6
      return 725
    end case
    case statenum_t.S_SSWV_STND
      return 726
    end case
    case statenum_t.S_SSWV_STND2
      return 727
    end case
    case statenum_t.S_SSWV_RUN1
      return 728
    end case
    case statenum_t.S_SSWV_RUN2
      return 729
    end case
    case statenum_t.S_SSWV_RUN3
      return 730
    end case
    case statenum_t.S_SSWV_RUN4
      return 731
    end case
    case statenum_t.S_SSWV_RUN5
      return 732
    end case
    case statenum_t.S_SSWV_RUN6
      return 733
    end case
    case statenum_t.S_SSWV_RUN7
      return 734
    end case
    case statenum_t.S_SSWV_RUN8
      return 735
    end case
    case statenum_t.S_SSWV_ATK1
      return 736
    end case
    case statenum_t.S_SSWV_ATK2
      return 737
    end case
    case statenum_t.S_SSWV_ATK3
      return 738
    end case
    case statenum_t.S_SSWV_ATK4
      return 739
    end case
    case statenum_t.S_SSWV_ATK5
      return 740
    end case
    case statenum_t.S_SSWV_ATK6
      return 741
    end case
    case statenum_t.S_SSWV_PAIN
      return 742
    end case
    case statenum_t.S_SSWV_PAIN2
      return 743
    end case
    case statenum_t.S_SSWV_DIE1
      return 744
    end case
    case statenum_t.S_SSWV_DIE2
      return 745
    end case
    case statenum_t.S_SSWV_DIE3
      return 746
    end case
    case statenum_t.S_SSWV_DIE4
      return 747
    end case
    case statenum_t.S_SSWV_DIE5
      return 748
    end case
    case statenum_t.S_SSWV_XDIE1
      return 749
    end case
    case statenum_t.S_SSWV_XDIE2
      return 750
    end case
    case statenum_t.S_SSWV_XDIE3
      return 751
    end case
    case statenum_t.S_SSWV_XDIE4
      return 752
    end case
    case statenum_t.S_SSWV_XDIE5
      return 753
    end case
    case statenum_t.S_SSWV_XDIE6
      return 754
    end case
    case statenum_t.S_SSWV_XDIE7
      return 755
    end case
    case statenum_t.S_SSWV_XDIE8
      return 756
    end case
    case statenum_t.S_SSWV_XDIE9
      return 757
    end case
    case statenum_t.S_SSWV_RAISE1
      return 758
    end case
    case statenum_t.S_SSWV_RAISE2
      return 759
    end case
    case statenum_t.S_SSWV_RAISE3
      return 760
    end case
    case statenum_t.S_SSWV_RAISE4
      return 761
    end case
    case statenum_t.S_SSWV_RAISE5
      return 762
    end case
    case statenum_t.S_KEENSTND
      return 763
    end case
    case statenum_t.S_COMMKEEN
      return 764
    end case
    case statenum_t.S_COMMKEEN2
      return 765
    end case
    case statenum_t.S_COMMKEEN3
      return 766
    end case
    case statenum_t.S_COMMKEEN4
      return 767
    end case
    case statenum_t.S_COMMKEEN5
      return 768
    end case
    case statenum_t.S_COMMKEEN6
      return 769
    end case
    case statenum_t.S_COMMKEEN7
      return 770
    end case
    case statenum_t.S_COMMKEEN8
      return 771
    end case
    case statenum_t.S_COMMKEEN9
      return 772
    end case
    case statenum_t.S_COMMKEEN10
      return 773
    end case
    case statenum_t.S_COMMKEEN11
      return 774
    end case
    case statenum_t.S_COMMKEEN12
      return 775
    end case
    case statenum_t.S_KEENPAIN
      return 776
    end case
    case statenum_t.S_KEENPAIN2
      return 777
    end case
    case statenum_t.S_BRAIN
      return 778
    end case
    case statenum_t.S_BRAIN_PAIN
      return 779
    end case
    case statenum_t.S_BRAIN_DIE1
      return 780
    end case
    case statenum_t.S_BRAIN_DIE2
      return 781
    end case
    case statenum_t.S_BRAIN_DIE3
      return 782
    end case
    case statenum_t.S_BRAIN_DIE4
      return 783
    end case
    case statenum_t.S_BRAINEYE
      return 784
    end case
    case statenum_t.S_BRAINEYESEE
      return 785
    end case
    case statenum_t.S_BRAINEYE1
      return 786
    end case
    case statenum_t.S_SPAWN1
      return 787
    end case
    case statenum_t.S_SPAWN2
      return 788
    end case
    case statenum_t.S_SPAWN3
      return 789
    end case
    case statenum_t.S_SPAWN4
      return 790
    end case
    case statenum_t.S_SPAWNFIRE1
      return 791
    end case
    case statenum_t.S_SPAWNFIRE2
      return 792
    end case
    case statenum_t.S_SPAWNFIRE3
      return 793
    end case
    case statenum_t.S_SPAWNFIRE4
      return 794
    end case
    case statenum_t.S_SPAWNFIRE5
      return 795
    end case
    case statenum_t.S_SPAWNFIRE6
      return 796
    end case
    case statenum_t.S_SPAWNFIRE7
      return 797
    end case
    case statenum_t.S_SPAWNFIRE8
      return 798
    end case
    case statenum_t.S_BRAINEXPLODE1
      return 799
    end case
    case statenum_t.S_BRAINEXPLODE2
      return 800
    end case
    case statenum_t.S_BRAINEXPLODE3
      return 801
    end case
    case statenum_t.S_ARM1
      return 802
    end case
    case statenum_t.S_ARM1A
      return 803
    end case
    case statenum_t.S_ARM2
      return 804
    end case
    case statenum_t.S_ARM2A
      return 805
    end case
    case statenum_t.S_BAR1
      return 806
    end case
    case statenum_t.S_BAR2
      return 807
    end case
    case statenum_t.S_BEXP
      return 808
    end case
    case statenum_t.S_BEXP2
      return 809
    end case
    case statenum_t.S_BEXP3
      return 810
    end case
    case statenum_t.S_BEXP4
      return 811
    end case
    case statenum_t.S_BEXP5
      return 812
    end case
    case statenum_t.S_BBAR1
      return 813
    end case
    case statenum_t.S_BBAR2
      return 814
    end case
    case statenum_t.S_BBAR3
      return 815
    end case
    case statenum_t.S_BON1
      return 816
    end case
    case statenum_t.S_BON1A
      return 817
    end case
    case statenum_t.S_BON1B
      return 818
    end case
    case statenum_t.S_BON1C
      return 819
    end case
    case statenum_t.S_BON1D
      return 820
    end case
    case statenum_t.S_BON1E
      return 821
    end case
    case statenum_t.S_BON2
      return 822
    end case
    case statenum_t.S_BON2A
      return 823
    end case
    case statenum_t.S_BON2B
      return 824
    end case
    case statenum_t.S_BON2C
      return 825
    end case
    case statenum_t.S_BON2D
      return 826
    end case
    case statenum_t.S_BON2E
      return 827
    end case
    case statenum_t.S_BKEY
      return 828
    end case
    case statenum_t.S_BKEY2
      return 829
    end case
    case statenum_t.S_RKEY
      return 830
    end case
    case statenum_t.S_RKEY2
      return 831
    end case
    case statenum_t.S_YKEY
      return 832
    end case
    case statenum_t.S_YKEY2
      return 833
    end case
    case statenum_t.S_BSKULL
      return 834
    end case
    case statenum_t.S_BSKULL2
      return 835
    end case
    case statenum_t.S_RSKULL
      return 836
    end case
    case statenum_t.S_RSKULL2
      return 837
    end case
    case statenum_t.S_YSKULL
      return 838
    end case
    case statenum_t.S_YSKULL2
      return 839
    end case
    case statenum_t.S_STIM
      return 840
    end case
    case statenum_t.S_MEDI
      return 841
    end case
    case statenum_t.S_SOUL
      return 842
    end case
    case statenum_t.S_SOUL2
      return 843
    end case
    case statenum_t.S_SOUL3
      return 844
    end case
    case statenum_t.S_SOUL4
      return 845
    end case
    case statenum_t.S_SOUL5
      return 846
    end case
    case statenum_t.S_SOUL6
      return 847
    end case
    case statenum_t.S_PINV
      return 848
    end case
    case statenum_t.S_PINV2
      return 849
    end case
    case statenum_t.S_PINV3
      return 850
    end case
    case statenum_t.S_PINV4
      return 851
    end case
    case statenum_t.S_PSTR
      return 852
    end case
    case statenum_t.S_PINS
      return 853
    end case
    case statenum_t.S_PINS2
      return 854
    end case
    case statenum_t.S_PINS3
      return 855
    end case
    case statenum_t.S_PINS4
      return 856
    end case
    case statenum_t.S_MEGA
      return 857
    end case
    case statenum_t.S_MEGA2
      return 858
    end case
    case statenum_t.S_MEGA3
      return 859
    end case
    case statenum_t.S_MEGA4
      return 860
    end case
    case statenum_t.S_SUIT
      return 861
    end case
    case statenum_t.S_PMAP
      return 862
    end case
    case statenum_t.S_PMAP2
      return 863
    end case
    case statenum_t.S_PMAP3
      return 864
    end case
    case statenum_t.S_PMAP4
      return 865
    end case
    case statenum_t.S_PMAP5
      return 866
    end case
    case statenum_t.S_PMAP6
      return 867
    end case
    case statenum_t.S_PVIS
      return 868
    end case
    case statenum_t.S_PVIS2
      return 869
    end case
    case statenum_t.S_CLIP
      return 870
    end case
    case statenum_t.S_AMMO
      return 871
    end case
    case statenum_t.S_ROCK
      return 872
    end case
    case statenum_t.S_BROK
      return 873
    end case
    case statenum_t.S_CELL
      return 874
    end case
    case statenum_t.S_CELP
      return 875
    end case
    case statenum_t.S_SHEL
      return 876
    end case
    case statenum_t.S_SBOX
      return 877
    end case
    case statenum_t.S_BPAK
      return 878
    end case
    case statenum_t.S_BFUG
      return 879
    end case
    case statenum_t.S_MGUN
      return 880
    end case
    case statenum_t.S_CSAW
      return 881
    end case
    case statenum_t.S_LAUN
      return 882
    end case
    case statenum_t.S_PLAS
      return 883
    end case
    case statenum_t.S_SHOT
      return 884
    end case
    case statenum_t.S_SHOT2
      return 885
    end case
    case statenum_t.S_COLU
      return 886
    end case
    case statenum_t.S_STALAG
      return 887
    end case
    case statenum_t.S_BLOODYTWITCH
      return 888
    end case
    case statenum_t.S_BLOODYTWITCH2
      return 889
    end case
    case statenum_t.S_BLOODYTWITCH3
      return 890
    end case
    case statenum_t.S_BLOODYTWITCH4
      return 891
    end case
    case statenum_t.S_DEADTORSO
      return 892
    end case
    case statenum_t.S_DEADBOTTOM
      return 893
    end case
    case statenum_t.S_HEADSONSTICK
      return 894
    end case
    case statenum_t.S_GIBS
      return 895
    end case
    case statenum_t.S_HEADONASTICK
      return 896
    end case
    case statenum_t.S_HEADCANDLES
      return 897
    end case
    case statenum_t.S_HEADCANDLES2
      return 898
    end case
    case statenum_t.S_DEADSTICK
      return 899
    end case
    case statenum_t.S_LIVESTICK
      return 900
    end case
    case statenum_t.S_LIVESTICK2
      return 901
    end case
    case statenum_t.S_MEAT2
      return 902
    end case
    case statenum_t.S_MEAT3
      return 903
    end case
    case statenum_t.S_MEAT4
      return 904
    end case
    case statenum_t.S_MEAT5
      return 905
    end case
    case statenum_t.S_STALAGTITE
      return 906
    end case
    case statenum_t.S_TALLGRNCOL
      return 907
    end case
    case statenum_t.S_SHRTGRNCOL
      return 908
    end case
    case statenum_t.S_TALLREDCOL
      return 909
    end case
    case statenum_t.S_SHRTREDCOL
      return 910
    end case
    case statenum_t.S_CANDLESTIK
      return 911
    end case
    case statenum_t.S_CANDELABRA
      return 912
    end case
    case statenum_t.S_SKULLCOL
      return 913
    end case
    case statenum_t.S_TORCHTREE
      return 914
    end case
    case statenum_t.S_BIGTREE
      return 915
    end case
    case statenum_t.S_TECHPILLAR
      return 916
    end case
    case statenum_t.S_EVILEYE
      return 917
    end case
    case statenum_t.S_EVILEYE2
      return 918
    end case
    case statenum_t.S_EVILEYE3
      return 919
    end case
    case statenum_t.S_EVILEYE4
      return 920
    end case
    case statenum_t.S_FLOATSKULL
      return 921
    end case
    case statenum_t.S_FLOATSKULL2
      return 922
    end case
    case statenum_t.S_FLOATSKULL3
      return 923
    end case
    case statenum_t.S_HEARTCOL
      return 924
    end case
    case statenum_t.S_HEARTCOL2
      return 925
    end case
    case statenum_t.S_BLUETORCH
      return 926
    end case
    case statenum_t.S_BLUETORCH2
      return 927
    end case
    case statenum_t.S_BLUETORCH3
      return 928
    end case
    case statenum_t.S_BLUETORCH4
      return 929
    end case
    case statenum_t.S_GREENTORCH
      return 930
    end case
    case statenum_t.S_GREENTORCH2
      return 931
    end case
    case statenum_t.S_GREENTORCH3
      return 932
    end case
    case statenum_t.S_GREENTORCH4
      return 933
    end case
    case statenum_t.S_REDTORCH
      return 934
    end case
    case statenum_t.S_REDTORCH2
      return 935
    end case
    case statenum_t.S_REDTORCH3
      return 936
    end case
    case statenum_t.S_REDTORCH4
      return 937
    end case
    case statenum_t.S_BTORCHSHRT
      return 938
    end case
    case statenum_t.S_BTORCHSHRT2
      return 939
    end case
    case statenum_t.S_BTORCHSHRT3
      return 940
    end case
    case statenum_t.S_BTORCHSHRT4
      return 941
    end case
    case statenum_t.S_GTORCHSHRT
      return 942
    end case
    case statenum_t.S_GTORCHSHRT2
      return 943
    end case
    case statenum_t.S_GTORCHSHRT3
      return 944
    end case
    case statenum_t.S_GTORCHSHRT4
      return 945
    end case
    case statenum_t.S_RTORCHSHRT
      return 946
    end case
    case statenum_t.S_RTORCHSHRT2
      return 947
    end case
    case statenum_t.S_RTORCHSHRT3
      return 948
    end case
    case statenum_t.S_RTORCHSHRT4
      return 949
    end case
    case statenum_t.S_HANGNOGUTS
      return 950
    end case
    case statenum_t.S_HANGBNOBRAIN
      return 951
    end case
    case statenum_t.S_HANGTLOOKDN
      return 952
    end case
    case statenum_t.S_HANGTSKULL
      return 953
    end case
    case statenum_t.S_HANGTLOOKUP
      return 954
    end case
    case statenum_t.S_HANGTNOBRAIN
      return 955
    end case
    case statenum_t.S_COLONGIBS
      return 956
    end case
    case statenum_t.S_SMALLPOOL
      return 957
    end case
    case statenum_t.S_BRAINSTEM
      return 958
    end case
    case statenum_t.S_TECHLAMP
      return 959
    end case
    case statenum_t.S_TECHLAMP2
      return 960
    end case
    case statenum_t.S_TECHLAMP3
      return 961
    end case
    case statenum_t.S_TECHLAMP4
      return 962
    end case
    case statenum_t.S_TECH2LAMP
      return 963
    end case
    case statenum_t.S_TECH2LAMP2
      return 964
    end case
    case statenum_t.S_TECH2LAMP3
      return 965
    end case
    case statenum_t.S_TECH2LAMP4
      return 966
    end case
    case default
      return -1
    end case
  end switch
end function

/*
* Function: Info_StateAt
* Purpose: Implements the Info_StateAt routine for the engine module behavior.
*/
function Info_StateAt(s)
  idx = Info_StateIndex(s)
  if idx < 0 then return void end if
  if typeof(states) != "array" then return void end if
  if idx >= len(states) then return void end if
  return states[idx]
end function



