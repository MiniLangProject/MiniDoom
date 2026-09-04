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

//! Defines sound-effect and music metadata records plus the canonical Doom audio identifier tables.


/// Defines one sound effect's lump name, priority, singularity, pitch, volume, cached data, and channel usage
/// count.
struct sfxinfo_t
  /// Stable resource or object name stored by `sfxinfo_t`
  name
  /// Stores singularity for `sfxinfo_t`
  singularity
  /// Stores priority for `sfxinfo_t`
  priority
  /// Stores link for `sfxinfo_t`
  link
  /// Stores pitch for `sfxinfo_t`
  pitch
  /// Stores volume for `sfxinfo_t`
  volume
  /// Payload owned or referenced by this record stored by `sfxinfo_t`
  data
  /// Stores usefulness for `sfxinfo_t`
  usefulness
  /// Stores lumpnum for `sfxinfo_t`
  lumpnum
end struct

/// Defines one music track's lump name together with its resolved lump number and backend playback handle.
struct musicinfo_t
  /// Stable resource or object name stored by `musicinfo_t`
  name
  /// Stores lumpnum for `musicinfo_t`
  lumpnum
  /// Payload owned or referenced by this record stored by `musicinfo_t`
  data
  /// Stores handle for `musicinfo_t`
  handle
end struct

/// Stores the s sfx collection used by the sounds subsystem.
S_sfx =[
sfxinfo_t("none", false, 0, 0, -1, -1, void, -1, -1),
sfxinfo_t("pistol", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("shotgn", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("sgcock", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("dshtgn", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("dbopn", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("dbcls", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("dbload", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("plasma", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("bfg", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("sawup", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("sawidl", false, 118, 0, -1, -1, void, -1, -1),
sfxinfo_t("sawful", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("sawhit", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("rlaunc", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("rxplod", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("firsht", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("firxpl", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("pstart", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("pstop", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("doropn", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("dorcls", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("stnmov", false, 119, 0, -1, -1, void, -1, -1),
sfxinfo_t("swtchn", false, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("swtchx", false, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("plpain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("dmpain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("popain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("vipain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("mnpain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("pepain", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("slop", false, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("itemup", true, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("wpnup", true, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("oof", false, 96, 0, -1, -1, void, -1, -1),
sfxinfo_t("telept", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("posit1", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("posit2", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("posit3", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("bgsit1", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("bgsit2", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("sgtsit", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("cacsit", true, 98, 0, -1, -1, void, -1, -1),
sfxinfo_t("brssit", true, 94, 0, -1, -1, void, -1, -1),
sfxinfo_t("cybsit", true, 92, 0, -1, -1, void, -1, -1),
sfxinfo_t("spisit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("bspsit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("kntsit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("vilsit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("mansit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("pesit", true, 90, 0, -1, -1, void, -1, -1),
sfxinfo_t("sklatk", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("sgtatk", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skepch", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("vilatk", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("claw", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skeswg", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("pldeth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("pdiehi", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("podth1", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("podth2", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("podth3", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("bgdth1", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("bgdth2", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("sgtdth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("cacdth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skldth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("brsdth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("cybdth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("spidth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("bspdth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("vildth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("kntdth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("pedth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("skedth", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("posact", true, 120, 0, -1, -1, void, -1, -1),
sfxinfo_t("bgact", true, 120, 0, -1, -1, void, -1, -1),
sfxinfo_t("dmact", true, 120, 0, -1, -1, void, -1, -1),
sfxinfo_t("bspact", true, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("bspwlk", true, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("vilact", true, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("noway", false, 78, 0, -1, -1, void, -1, -1),
sfxinfo_t("barexp", false, 60, 0, -1, -1, void, -1, -1),
sfxinfo_t("punch", false, 64, 0, -1, -1, void, -1, -1),
sfxinfo_t("hoof", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("metal", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("chgun", false, 64, 1, 150, 0, void, -1, -1),
sfxinfo_t("tink", false, 60, 0, -1, -1, void, -1, -1),
sfxinfo_t("bdopn", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("bdcls", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("itmbk", false, 100, 0, -1, -1, void, -1, -1),
sfxinfo_t("flame", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("flamst", false, 32, 0, -1, -1, void, -1, -1),
sfxinfo_t("getpow", false, 60, 0, -1, -1, void, -1, -1),
sfxinfo_t("bospit", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("boscub", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("bossit", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("bospn", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("bosdth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("manatk", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("mandth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("sssit", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("ssdth", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("keenpn", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("keendt", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skeact", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skesit", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("skeatk", false, 70, 0, -1, -1, void, -1, -1),
sfxinfo_t("radio", false, 60, 0, -1, -1, void, -1, -1)
]

/// Stores the s music collection used by the sounds subsystem.
S_music =[
musicinfo_t("", 0, void, 0),
musicinfo_t("e1m1", 0, void, 0),
musicinfo_t("e1m2", 0, void, 0),
musicinfo_t("e1m3", 0, void, 0),
musicinfo_t("e1m4", 0, void, 0),
musicinfo_t("e1m5", 0, void, 0),
musicinfo_t("e1m6", 0, void, 0),
musicinfo_t("e1m7", 0, void, 0),
musicinfo_t("e1m8", 0, void, 0),
musicinfo_t("e1m9", 0, void, 0),
musicinfo_t("e2m1", 0, void, 0),
musicinfo_t("e2m2", 0, void, 0),
musicinfo_t("e2m3", 0, void, 0),
musicinfo_t("e2m4", 0, void, 0),
musicinfo_t("e2m5", 0, void, 0),
musicinfo_t("e2m6", 0, void, 0),
musicinfo_t("e2m7", 0, void, 0),
musicinfo_t("e2m8", 0, void, 0),
musicinfo_t("e2m9", 0, void, 0),
musicinfo_t("e3m1", 0, void, 0),
musicinfo_t("e3m2", 0, void, 0),
musicinfo_t("e3m3", 0, void, 0),
musicinfo_t("e3m4", 0, void, 0),
musicinfo_t("e3m5", 0, void, 0),
musicinfo_t("e3m6", 0, void, 0),
musicinfo_t("e3m7", 0, void, 0),
musicinfo_t("e3m8", 0, void, 0),
musicinfo_t("e3m9", 0, void, 0),
musicinfo_t("inter", 0, void, 0),
musicinfo_t("intro", 0, void, 0),
musicinfo_t("bunny", 0, void, 0),
musicinfo_t("victor", 0, void, 0),
musicinfo_t("introa", 0, void, 0),
musicinfo_t("runnin", 0, void, 0),
musicinfo_t("stalks", 0, void, 0),
musicinfo_t("countd", 0, void, 0),
musicinfo_t("betwee", 0, void, 0),
musicinfo_t("doom", 0, void, 0),
musicinfo_t("the_da", 0, void, 0),
musicinfo_t("shawn", 0, void, 0),
musicinfo_t("ddtblu", 0, void, 0),
musicinfo_t("in_cit", 0, void, 0),
musicinfo_t("dead", 0, void, 0),
musicinfo_t("stlks2", 0, void, 0),
musicinfo_t("theda2", 0, void, 0),
musicinfo_t("doom2", 0, void, 0),
musicinfo_t("ddtbl2", 0, void, 0),
musicinfo_t("runni2", 0, void, 0),
musicinfo_t("dead2", 0, void, 0),
musicinfo_t("stlks3", 0, void, 0),
musicinfo_t("romero", 0, void, 0),
musicinfo_t("shawn2", 0, void, 0),
musicinfo_t("messag", 0, void, 0),
musicinfo_t("count2", 0, void, 0),
musicinfo_t("ddtbl3", 0, void, 0),
musicinfo_t("ampie", 0, void, 0),
musicinfo_t("theda3", 0, void, 0),
musicinfo_t("adrian", 0, void, 0),
musicinfo_t("messg2", 0, void, 0),
musicinfo_t("romer2", 0, void, 0),
musicinfo_t("tense", 0, void, 0),
musicinfo_t("shawn3", 0, void, 0),
musicinfo_t("openin", 0, void, 0),
musicinfo_t("evil", 0, void, 0),
musicinfo_t("ultima", 0, void, 0),
musicinfo_t("read_m", 0, void, 0),
musicinfo_t("dm2ttl", 0, void, 0),
musicinfo_t("dm2int", 0, void, 0)
]

/// Assigns stable identifiers to level, intermission, finale, and title music tracks.
enum musicenum_t
  /// Represents mus none in `musicenum_t`
  mus_None
  /// Represents mus e1m1 in `musicenum_t`
  mus_e1m1
  /// Represents mus e1m2 in `musicenum_t`
  mus_e1m2
  /// Represents mus e1m3 in `musicenum_t`
  mus_e1m3
  /// Represents mus e1m4 in `musicenum_t`
  mus_e1m4
  /// Represents mus e1m5 in `musicenum_t`
  mus_e1m5
  /// Represents mus e1m6 in `musicenum_t`
  mus_e1m6
  /// Represents mus e1m7 in `musicenum_t`
  mus_e1m7
  /// Represents mus e1m8 in `musicenum_t`
  mus_e1m8
  /// Represents mus e1m9 in `musicenum_t`
  mus_e1m9
  /// Represents mus e2m1 in `musicenum_t`
  mus_e2m1
  /// Represents mus e2m2 in `musicenum_t`
  mus_e2m2
  /// Represents mus e2m3 in `musicenum_t`
  mus_e2m3
  /// Represents mus e2m4 in `musicenum_t`
  mus_e2m4
  /// Represents mus e2m5 in `musicenum_t`
  mus_e2m5
  /// Represents mus e2m6 in `musicenum_t`
  mus_e2m6
  /// Represents mus e2m7 in `musicenum_t`
  mus_e2m7
  /// Represents mus e2m8 in `musicenum_t`
  mus_e2m8
  /// Represents mus e2m9 in `musicenum_t`
  mus_e2m9
  /// Represents mus e3m1 in `musicenum_t`
  mus_e3m1
  /// Represents mus e3m2 in `musicenum_t`
  mus_e3m2
  /// Represents mus e3m3 in `musicenum_t`
  mus_e3m3
  /// Represents mus e3m4 in `musicenum_t`
  mus_e3m4
  /// Represents mus e3m5 in `musicenum_t`
  mus_e3m5
  /// Represents mus e3m6 in `musicenum_t`
  mus_e3m6
  /// Represents mus e3m7 in `musicenum_t`
  mus_e3m7
  /// Represents mus e3m8 in `musicenum_t`
  mus_e3m8
  /// Represents mus e3m9 in `musicenum_t`
  mus_e3m9
  /// Represents mus inter in `musicenum_t`
  mus_inter
  /// Represents mus intro in `musicenum_t`
  mus_intro
  /// Represents mus bunny in `musicenum_t`
  mus_bunny
  /// Represents mus victor in `musicenum_t`
  mus_victor
  /// Represents mus introa in `musicenum_t`
  mus_introa
  /// Represents mus runnin in `musicenum_t`
  mus_runnin
  /// Represents mus stalks in `musicenum_t`
  mus_stalks
  /// Represents mus countd in `musicenum_t`
  mus_countd
  /// Represents mus betwee in `musicenum_t`
  mus_betwee
  /// Represents mus doom in `musicenum_t`
  mus_doom
  /// Represents mus the da in `musicenum_t`
  mus_the_da
  /// Represents mus shawn in `musicenum_t`
  mus_shawn
  /// Represents mus ddtblu in `musicenum_t`
  mus_ddtblu
  /// Represents mus in cit in `musicenum_t`
  mus_in_cit
  /// Represents mus dead in `musicenum_t`
  mus_dead
  /// Represents mus stlks2 in `musicenum_t`
  mus_stlks2
  /// Represents mus theda2 in `musicenum_t`
  mus_theda2
  /// Represents mus doom2 in `musicenum_t`
  mus_doom2
  /// Represents mus ddtbl2 in `musicenum_t`
  mus_ddtbl2
  /// Represents mus runni2 in `musicenum_t`
  mus_runni2
  /// Represents mus dead2 in `musicenum_t`
  mus_dead2
  /// Represents mus stlks3 in `musicenum_t`
  mus_stlks3
  /// Represents mus romero in `musicenum_t`
  mus_romero
  /// Represents mus shawn2 in `musicenum_t`
  mus_shawn2
  /// Represents mus messag in `musicenum_t`
  mus_messag
  /// Represents mus count2 in `musicenum_t`
  mus_count2
  /// Represents mus ddtbl3 in `musicenum_t`
  mus_ddtbl3
  /// Represents mus ampie in `musicenum_t`
  mus_ampie
  /// Represents mus theda3 in `musicenum_t`
  mus_theda3
  /// Represents mus adrian in `musicenum_t`
  mus_adrian
  /// Represents mus messg2 in `musicenum_t`
  mus_messg2
  /// Represents mus romer2 in `musicenum_t`
  mus_romer2
  /// Represents mus tense in `musicenum_t`
  mus_tense
  /// Represents mus shawn3 in `musicenum_t`
  mus_shawn3
  /// Represents mus openin in `musicenum_t`
  mus_openin
  /// Represents mus evil in `musicenum_t`
  mus_evil
  /// Represents mus ultima in `musicenum_t`
  mus_ultima
  /// Represents mus read m in `musicenum_t`
  mus_read_m
  /// Represents mus dm2ttl in `musicenum_t`
  mus_dm2ttl
  /// Represents mus dm2int in `musicenum_t`
  mus_dm2int
  /// Marks the number of values represented by `musicenum_t`
  NUMMUSIC
end enum

/// Assigns stable identifiers to every weapon, actor, world, and UI sound effect.
enum sfxenum_t
  /// Represents sfx none in `sfxenum_t`
  sfx_None
  /// Represents sfx pistol in `sfxenum_t`
  sfx_pistol
  /// Represents sfx shotgn in `sfxenum_t`
  sfx_shotgn
  /// Represents sfx sgcock in `sfxenum_t`
  sfx_sgcock
  /// Represents sfx dshtgn in `sfxenum_t`
  sfx_dshtgn
  /// Represents sfx dbopn in `sfxenum_t`
  sfx_dbopn
  /// Represents sfx dbcls in `sfxenum_t`
  sfx_dbcls
  /// Represents sfx dbload in `sfxenum_t`
  sfx_dbload
  /// Represents sfx plasma in `sfxenum_t`
  sfx_plasma
  /// Represents sfx bfg in `sfxenum_t`
  sfx_bfg
  /// Represents sfx sawup in `sfxenum_t`
  sfx_sawup
  /// Represents sfx sawidl in `sfxenum_t`
  sfx_sawidl
  /// Represents sfx sawful in `sfxenum_t`
  sfx_sawful
  /// Represents sfx sawhit in `sfxenum_t`
  sfx_sawhit
  /// Represents sfx rlaunc in `sfxenum_t`
  sfx_rlaunc
  /// Represents sfx rxplod in `sfxenum_t`
  sfx_rxplod
  /// Represents sfx firsht in `sfxenum_t`
  sfx_firsht
  /// Represents sfx firxpl in `sfxenum_t`
  sfx_firxpl
  /// Represents sfx pstart in `sfxenum_t`
  sfx_pstart
  /// Represents sfx pstop in `sfxenum_t`
  sfx_pstop
  /// Represents sfx doropn in `sfxenum_t`
  sfx_doropn
  /// Represents sfx dorcls in `sfxenum_t`
  sfx_dorcls
  /// Represents sfx stnmov in `sfxenum_t`
  sfx_stnmov
  /// Represents sfx swtchn in `sfxenum_t`
  sfx_swtchn
  /// Represents sfx swtchx in `sfxenum_t`
  sfx_swtchx
  /// Represents sfx plpain in `sfxenum_t`
  sfx_plpain
  /// Represents sfx dmpain in `sfxenum_t`
  sfx_dmpain
  /// Represents sfx popain in `sfxenum_t`
  sfx_popain
  /// Represents sfx vipain in `sfxenum_t`
  sfx_vipain
  /// Represents sfx mnpain in `sfxenum_t`
  sfx_mnpain
  /// Represents sfx pepain in `sfxenum_t`
  sfx_pepain
  /// Represents sfx slop in `sfxenum_t`
  sfx_slop
  /// Represents sfx itemup in `sfxenum_t`
  sfx_itemup
  /// Represents sfx wpnup in `sfxenum_t`
  sfx_wpnup
  /// Represents sfx oof in `sfxenum_t`
  sfx_oof
  /// Represents sfx telept in `sfxenum_t`
  sfx_telept
  /// Represents sfx posit1 in `sfxenum_t`
  sfx_posit1
  /// Represents sfx posit2 in `sfxenum_t`
  sfx_posit2
  /// Represents sfx posit3 in `sfxenum_t`
  sfx_posit3
  /// Represents sfx bgsit1 in `sfxenum_t`
  sfx_bgsit1
  /// Represents sfx bgsit2 in `sfxenum_t`
  sfx_bgsit2
  /// Represents sfx sgtsit in `sfxenum_t`
  sfx_sgtsit
  /// Represents sfx cacsit in `sfxenum_t`
  sfx_cacsit
  /// Represents sfx brssit in `sfxenum_t`
  sfx_brssit
  /// Represents sfx cybsit in `sfxenum_t`
  sfx_cybsit
  /// Represents sfx spisit in `sfxenum_t`
  sfx_spisit
  /// Represents sfx bspsit in `sfxenum_t`
  sfx_bspsit
  /// Represents sfx kntsit in `sfxenum_t`
  sfx_kntsit
  /// Represents sfx vilsit in `sfxenum_t`
  sfx_vilsit
  /// Represents sfx mansit in `sfxenum_t`
  sfx_mansit
  /// Represents sfx pesit in `sfxenum_t`
  sfx_pesit
  /// Represents sfx sklatk in `sfxenum_t`
  sfx_sklatk
  /// Represents sfx sgtatk in `sfxenum_t`
  sfx_sgtatk
  /// Represents sfx skepch in `sfxenum_t`
  sfx_skepch
  /// Represents sfx vilatk in `sfxenum_t`
  sfx_vilatk
  /// Represents sfx claw in `sfxenum_t`
  sfx_claw
  /// Represents sfx skeswg in `sfxenum_t`
  sfx_skeswg
  /// Represents sfx pldeth in `sfxenum_t`
  sfx_pldeth
  /// Represents sfx pdiehi in `sfxenum_t`
  sfx_pdiehi
  /// Represents sfx podth1 in `sfxenum_t`
  sfx_podth1
  /// Represents sfx podth2 in `sfxenum_t`
  sfx_podth2
  /// Represents sfx podth3 in `sfxenum_t`
  sfx_podth3
  /// Represents sfx bgdth1 in `sfxenum_t`
  sfx_bgdth1
  /// Represents sfx bgdth2 in `sfxenum_t`
  sfx_bgdth2
  /// Represents sfx sgtdth in `sfxenum_t`
  sfx_sgtdth
  /// Represents sfx cacdth in `sfxenum_t`
  sfx_cacdth
  /// Represents sfx skldth in `sfxenum_t`
  sfx_skldth
  /// Represents sfx brsdth in `sfxenum_t`
  sfx_brsdth
  /// Represents sfx cybdth in `sfxenum_t`
  sfx_cybdth
  /// Represents sfx spidth in `sfxenum_t`
  sfx_spidth
  /// Represents sfx bspdth in `sfxenum_t`
  sfx_bspdth
  /// Represents sfx vildth in `sfxenum_t`
  sfx_vildth
  /// Represents sfx kntdth in `sfxenum_t`
  sfx_kntdth
  /// Represents sfx pedth in `sfxenum_t`
  sfx_pedth
  /// Represents sfx skedth in `sfxenum_t`
  sfx_skedth
  /// Represents sfx posact in `sfxenum_t`
  sfx_posact
  /// Represents sfx bgact in `sfxenum_t`
  sfx_bgact
  /// Represents sfx dmact in `sfxenum_t`
  sfx_dmact
  /// Represents sfx bspact in `sfxenum_t`
  sfx_bspact
  /// Represents sfx bspwlk in `sfxenum_t`
  sfx_bspwlk
  /// Represents sfx vilact in `sfxenum_t`
  sfx_vilact
  /// Represents sfx noway in `sfxenum_t`
  sfx_noway
  /// Represents sfx barexp in `sfxenum_t`
  sfx_barexp
  /// Represents sfx punch in `sfxenum_t`
  sfx_punch
  /// Represents sfx hoof in `sfxenum_t`
  sfx_hoof
  /// Represents sfx metal in `sfxenum_t`
  sfx_metal
  /// Represents sfx chgun in `sfxenum_t`
  sfx_chgun
  /// Represents sfx tink in `sfxenum_t`
  sfx_tink
  /// Represents sfx bdopn in `sfxenum_t`
  sfx_bdopn
  /// Represents sfx bdcls in `sfxenum_t`
  sfx_bdcls
  /// Represents sfx itmbk in `sfxenum_t`
  sfx_itmbk
  /// Represents sfx flame in `sfxenum_t`
  sfx_flame
  /// Represents sfx flamst in `sfxenum_t`
  sfx_flamst
  /// Represents sfx getpow in `sfxenum_t`
  sfx_getpow
  /// Represents sfx bospit in `sfxenum_t`
  sfx_bospit
  /// Represents sfx boscub in `sfxenum_t`
  sfx_boscub
  /// Represents sfx bossit in `sfxenum_t`
  sfx_bossit
  /// Represents sfx bospn in `sfxenum_t`
  sfx_bospn
  /// Represents sfx bosdth in `sfxenum_t`
  sfx_bosdth
  /// Represents sfx manatk in `sfxenum_t`
  sfx_manatk
  /// Represents sfx mandth in `sfxenum_t`
  sfx_mandth
  /// Represents sfx sssit in `sfxenum_t`
  sfx_sssit
  /// Represents sfx ssdth in `sfxenum_t`
  sfx_ssdth
  /// Represents sfx keenpn in `sfxenum_t`
  sfx_keenpn
  /// Represents sfx keendt in `sfxenum_t`
  sfx_keendt
  /// Represents sfx skeact in `sfxenum_t`
  sfx_skeact
  /// Represents sfx skesit in `sfxenum_t`
  sfx_skesit
  /// Represents sfx skeatk in `sfxenum_t`
  sfx_skeatk
  /// Represents sfx radio in `sfxenum_t`
  sfx_radio
  /// Marks the number of values represented by `sfxenum_t`
  NUMSFX
end enum



